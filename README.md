# PlantSci_BigData

This repository contains the workshop materials used in the [2020 UF Plant Science Symposium on Big Data](https://www.ufplants.org/2020-plant-science-symposium).

## Workshop description

Decades of genomic data collection have resulted in robust software tools, methodologies, and analysis pipelines to and interpret large datasets, resulting in scientific discoveries (cloned genes, QTL, genetic markers, etc.). The rapid upsurge in sensor based phenomic technologies and broad scientific adoption has led to a demand for open-source data processing pipelines and FAIR (Findable, Accessible, Interoperable, and Re-usable) metadata. To date, most open-source image processing pipelines are custom scripts unique to each research objective. In this workshop we will discuss approaches to developing a data extraction pipeline for plant height from UAS image-based point clouds of maize.

Topics will cover ground control points, UAS image collection, image processing, data extraction, and application of UAS phenotypes within areas of statistical modeling and genetic mapping. The focus of the workshop will be to walk through how one may critically identify and combine the  necessary processing steps within their own pipeline, past the image processing stage, to extract your phenotypes of interest. Having hands on experience extracting the meaningful information from a large dataset will give participants skills necessary to develop their own pipelines, create publicly available processing tools, and provide FAIR data to the research community.

### Workshop Leaders

**Matthew Gitzendanner**: Dr. Matt Gitzendanner is a Scientist in the Biology Department at the University of Florida.  His research focuses on plant evolutionary genomics and big data. In addition to managing the lab for Pam and Doug Soltis, he works ¼ time for Research computing where he manages the training program and supports researchers across campus in their use of HiPerGator.

**Steven Anderson**: Dr. Steve Anderson is a Postdoctoral Researcher in the Environmental Horticulture Department at the University of Florida. His research focuses on novel plant breeding approaches, high-throughput phenotyping, quantitative genetics, and statistical modeling. He currently leads the Industrial Hemp Pilot Project Research at MREC developing best management practices for upcoming hemp cultivation in Florida diverse environment. Dr. Anderson strives to be an innovative, dynamic leader advocating for improved support/funding of advancements in agricultural production and sustainability through implementation of new technologies, multi-disciplinary collaboration, and educational resources.

### Overview

The workshop is based on and uses data from Anderson et al (2019), which describes a method of using Unmanned Aerial Systems (UAS) equiped with lidar and other sensors to measure individual plant height in a field of maize plants. These data can then be correlated with genotypic data for these plants to conduct a genome-wide association study of plant height.

While the data and some of the scripts used in the workshop are from the Anderson et al (2019) paper, and the lead author is one of the workshop leaders, the analyses have been modified from those used in the publication to fit the workshop format and computational resources. They are not the original data analysis pipelines used for the publication.

### [Hands-on for the workshop](Hands-on.md)

The workshop content and hands-on directions are on the [Hand-on page](Hands-on.md).

### Large Files

Two of the needed data files are too large to store in github. These files need to be downloaded separately. For the workshop, the paths in the scripts point to copies of the files on HiPerGator and users do not need to download them. For other users, you will want to download the files from the links below, put the files in the Workshop/Data directory, uncomment the lines with those paths and comment out, or delete, the lines using `/ufrc/general_workshop/share/Large_files/`.

* [20180622_cs_sony_corn_3dpc.las](https://www.dropbox.com/s/82dk8soz80v0nv2/20180622_cs_sony_corn_3dpc.las?dl=0) (about 1.4GB)
* [20180622_cs_sony_corn_mosaic.tif](https://www.dropbox.com/s/j56sj3dhpbpsahx/20180622_cs_sony_corn_mosaic.tif?dl=0) (about 900MB)

### Citations

Anderson, S. L., S. C. Murray, L. Malambo, C. Ratcliff, S. Popescu, D. Cope, A. Chang, J. Jung, and J. A. Thomasson. 2019. Prediction of Maize Grain Yield before Maturity Using Improved Temporal Height Estimates of Unmanned Aerial Systems. Plant Phenome J. 2:190004. [doi:10.2135/tppj2019.02.0004](https://dl.sciencesocieties.org/publications/tppj/articles/2/1/190004)

Alexander E. Lipka, Feng Tian, Qishan Wang, Jason Peiffer, Meng Li, Peter J. Bradbury, Michael A. Gore, Edward S. Buckler, Zhiwu Zhang, GAPIT: genome association and prediction integrated tool, Bioinformatics, Volume 28, Issue 18, 15 September 2012, Pages 2397–2399, https://doi.org/10.1093/bioinformatics/bts444

