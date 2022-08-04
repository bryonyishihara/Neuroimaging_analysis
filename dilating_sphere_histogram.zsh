#!/bin/zsh

# dilating sphere for lesion histogram
# run from sourcedata/ses-/anat directory
# define x,y,z seed coordinate

# $1 = nifti file of interest
# seed region coordinate
# $2 = x
# $3 = y
# $4 = z

if [[ "${1}" == *"t2"* ]] ; then
  suffix=t2
  echo suffix is ${suffix}
  elif [[ "${1}" == *"flair"* ]] ; then
  suffix=flair
  echo suffix is ${suffix}
  elif [[ "${1}" == *"swi"* ]] ; then
  suffix=swi
  echo suffix is ${suffix}
  elif [[ "${1}" == *"fgatir"* ]] ; then
  suffix=fgatir
  echo suffix is ${suffix}
  else echo unknown suffix
fi


#mkdir $PWD/../../../derivatives/ses-postop1/anat/dilating_sphere

savepath=$PWD/../../../derivatives/ses-postop1/anat/dilating_sphere

#fslmaths $1 -mul 0 -add 1 -roi $2 1 $3 1 $4 1 0 1 ${savepath}/lesion_centre_${suffix}.nii.gz -odt float

#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 1 -fmean ${savepath}/lesion_sphere_${suffix}_1.nii.gz -odt float
fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 1.5 -fmean ${savepath}/lesion_sphere_${suffix}_1.5.nii.gz -odt float
#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 2 -fmean ${savepath}/lesion_sphere_${suffix}_2.nii.gz -odt float
fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 2.5 -fmean ${savepath}/lesion_sphere_${suffix}_2.5.nii.gz -odt float
#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 3 -fmean ${savepath}/lesion_sphere_${suffix}_3.nii.gz -odt float
fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 3.5 -fmean ${savepath}/lesion_sphere_${suffix}_3.5.nii.gz -odt float
#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 4 -fmean ${savepath}/lesion_sphere_${suffix}_4.nii.gz -odt float
fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 4.5 -fmean ${savepath}/lesion_sphere_${suffix}_4.5.nii.gz -odt float
#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 5 -fmean ${savepath}/lesion_sphere_${suffix}_5.nii.gz -odt float
fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 5.5 -fmean ${savepath}/lesion_sphere_${suffix}_5.5.nii.gz -odt float
#fslmaths ${savepath}/lesion_centre_${suffix}.nii.gz -kernel sphere 6 -fmean ${savepath}/lesion_sphere_${suffix}_6.nii.gz -odt float

#binarise masks

for file in ${savepath}/lesion_sphere_${suffix}_* ; do
    filename=$(basename ${file} .nii.gz)
    fslmaths ${file} -thr 0.00000001 -bin ${savepath}/${filename}_bin.nii.gz
done

# subtract masks to get rings
mkdir ${savepath}/lesion_rings_2
fslmaths ${savepath}/lesion_sphere_${suffix}_6_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_5.5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_11.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_5.5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_10.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_4.5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_9.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_4.5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_4_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_8.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_4_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_3.5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_7.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_3.5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_3_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_6.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_3_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_2.5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_5.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_2.5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_2_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_4.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_2_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_1.5_bin.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_3.nii.gz
mv ${savepath}/lesion_sphere_${suffix}_1_bin.nii.gz ${savepath}/lesion_ring_${suffix}_1.nii.gz
fslmaths ${savepath}/lesion_sphere_${suffix}_1.5_bin.nii.gz -sub ${savepath}/lesion_ring_${suffix}_1.nii.gz ${savepath}/lesion_rings_2/lesion_ring_${suffix}_2.nii.gz


#fslmaths ${savepath}/lesion_sphere_${suffix}_6_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_5_bin.nii.gz ${savepath}/lesion_ring_${suffix}_6.nii.gz
#fslmaths ${savepath}/lesion_sphere_${suffix}_5_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_4_bin.nii.gz ${savepath}/lesion_ring_${suffix}_5.nii.gz
#fslmaths ${savepath}/lesion_sphere_${suffix}_4_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_3_bin.nii.gz ${savepath}/lesion_ring_${suffix}_4.nii.gz
#fslmaths ${savepath}/lesion_sphere_${suffix}_3_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_2_bin.nii.gz ${savepath}/lesion_ring_${suffix}_3.nii.gz
#fslmaths ${savepath}/lesion_sphere_${suffix}_2_bin.nii.gz -sub ${savepath}/lesion_sphere_${suffix}_1_bin.nii.gz ${savepath}/lesion_ring_${suffix}_2.nii.gz
#mv ${savepath}/lesion_sphere_${suffix}_1_bin.nii.gz ${savepath}/lesion_ring_${suffix}_1.nii.gz

# halve masks

#for file in ${savepath}/lesion_ring_${suffix}_*.nii.gz ; do
#  filename=$(basename ${file} .nii.gz)
#  fslmaths ${file} -roi 0 $2 0 -1 0 -1 0 -1 ${savepath}/${filename}_left.nii.gz
#  if [[ "${1}" == *"t2"* ]] ; then
#    x=`expr 193 - $2`
#    fslmaths ${file} -roi 194 -${x} 1 -1 1 -1 0 1 ${savepath}/${filename}_right.nii.gz
#    elif [[ "${1}" == *"flair"* ]] ; then
#      x=`expr 321 - $2`
#      fslmaths ${file} -roi 322 -${x} 1 -1 1 -1 0 1 ${savepath}/${filename}_right.nii.gz
#    elif [[ "${1}" == *"swi"* ]] ; then
#      x=`expr 448 - $2`
#      fslmaths ${file} -roi 449 -${x} 1 -1 1 -1 0 1 ${savepath}/${filename}_right.nii.gz
#    elif [[ "${1}" == *"fgatir"* ]] ; then
#      x=`expr 180 - $2`
#      fslmaths ${file} -roi 181 -${x} 1 -1 1 -1 0 1 ${savepath}/${filename}_right.nii.gz
#    else echo unknown file
#  fi
#done

#get intensity values

for file in ${savepath}/lesion_rings_2/lesion_ring_${suffix}_* ; do
    echo ${file}
    fslstats $1 -k ${file} -m -s -M -S
done
