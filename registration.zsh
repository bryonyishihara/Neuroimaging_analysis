#!/bin/zsh

# registers T2 and FLAIR images to T1, then T1 to MNI
# uses lesion cost function weighting
# applies warp to T2 and FLAIR lesion masks and binarises

FILE1=MPRAGE_brain.nii.gz
FILE2=T2_brain.nii.gz
FILE3=FLAIR_brain.nii.gz

  #make directory
  mkdir registration_cfw

  # register T2 and FLAIR to T1 and produce slices
  if test -f "${FILE2}"; then

    flirt -inweight T2_lesion_weighting.nii.gz -in ${FILE2} -ref ${FILE1} -out registration_cfw/T2toT1.nii.gz -omat registration_cfw/T2toT1.mat -dof 6

    echo "${FILE2} to T1 registration done"

    slicer ${FILE1} registration_cfw/T2toT1.nii.gz -a registration_cfw/T2toT1_reg_check.ppm

  else

    echo no "${FILE2}"

  fi


  if test -f "${FILE3}"; then

      flirt -inweight FLAIR_lesion_weighting.nii.gz -in ${FILE3} -ref ${FILE1} -out registration_cfw/FLAIRtoT1.nii.gz -omat registration_cfw/FLAIRtoT1.mat -dof 6

      echo "${FILE3} to T1 registration done"

      slicer ${FILE1} registration_cfw/FLAIRtoT1.nii.gz -a registration_cfw/FLAIRtoT1_reg_check.ppm

  else

    echo no "${FILE3}"

  fi

  # register T1 to MNI space

  # flirt uses _brain
  flirt -inweight T1_lesion_weighting.nii.gz -in ${FILE1} -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz -dof 12 -out registration_cfw/T1toMNIlin -omat registration_cfw/T1toMNIlin.mat
  echo "T1 to MNI flirt done"

  slicer $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz registration_cfw/T1toMNIlin.nii.gz -a registration_cfw/T1toMNI_linreg_slices.ppm

  # fnirt uses original T1
  fnirt --in=MPRAGE.nii.gz --inmask=T1_lesion_weighting.nii.gz --aff=registration_cfw/T1toMNIlin.mat --config=$FSLDIR/src/fnirt/fnirtcnf/T1_2_MNI152_2mm.cnf --iout=registration_cfw/T1toMNInonlin --cout=registration_cfw/T1toMNI_coef --fout=registration_cfw/T1toMNI_warp
  echo "T1 to MNI fnirt done"

  slicer $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz registration_cfw/T1toMNInonlin.nii.gz -a registration_cfw/T1toMNI_nonlinreg_slices.ppm

  # apply warp to masks
  applywarp -i T2_lesion2_mask.nii.gz -r $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz --premat=registration_cfw/T2toT1.mat -w registration_cfw/T1toMNI_warp.nii.gz -o registration_cfw/T2toMNI_lesion_mask.nii.gz
  applywarp -i FLAIR_lesion2_mask.nii.gz -r $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz --premat=registration_cfw/FLAIRtoT1.mat -w registration_cfw/T1toMNI_warp.nii.gz -o registration_cfw/FLAIRtoMNI_lesion_mask.nii.gz

  # threshold and binarise masks
  fslmaths registration_cfw/T2toMNI_lesion_mask.nii.gz -thr 0.3 -bin registration_cfw/T2toMNI_lesion_mask_bin.nii.gz
  fslmaths registration_cfw/FLAIRtoMNI_lesion_mask.nii.gz -thr 0.3 -bin registration_cfw/FLAIRtoMNI_lesion_mask_bin.nii.gz
