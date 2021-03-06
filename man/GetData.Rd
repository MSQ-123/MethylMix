% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Download_Preprocess.R
\name{GetData}
\alias{GetData}
\title{The GetData function}
\usage{
GetData(cancerSite, targetDirectory)
}
\arguments{
\item{cancerSite}{character of length 1 with TCGA cancer code.}

\item{targetDirectory}{character with directory where a folder for downloaded files will be created.}
}
\value{
The following files will be created in target directory:
\itemize{
 \item \code{gdac}: a folder with the raw data downloaded from TCGA.
 \item \code{MET_CancerSite_Processed.rds}: processed methylation data at the CpG sites level (not clustered).
 \item \code{GE_CancerSite_Processed.rds}: processed gene expression data.
 \item \code{data_CancerSite.rds}: list with both gene expression and methylation data. Methylation data is clustered and presented at the gene level. A matrix with the mapping from CpG sites to genes is included.
}
}
\description{
This function wraps the functions for downloading and pre-processing DNA methylation and gene expression data,
as well as for clustering CpG probes.
}
\details{
Pre-process of DNA methylation data includes eliminating samples and genes with too many NAs, imputing NAs, and doing Batch correction.
If there is both 27k and 450k data, and both data sets have more than 50 samples, we combine the data sets, by reducing the 450k data to the probes present in the 27k data, and bath correction is performed again to the combined data set.
If there are samples with both 27k and 450k data, the 450k data is used and the 27k data is discarded, before the step mentioned above.
If the 27k or the 450k data does not have more than 50 samples, we use the one with the greatest number of samples, we do not combine the data sets.

For gene expression, this function downloads RNAseq data (file tag "mRNAseq_Preprocess.Level_3"), with the exception for OV and GBM, for which micro array data is
downloaded since there is not enough RNAseq data. Pre-process of gene expression data includes eliminating samples and genes with too many NAs, imputing NAs, and doing Batch correction.

For the clustering of the CpG probes, this function uses the annotation for Illumina methylation arrays to map each probe to a gene. Then, for each gene,
it clusters all its CpG sites using hierchical clustering and Pearson correlation as distance and complete linkage. 
If data for normal samples is provided, only overlapping probes between cancer and normal samples are used. 
Probes with SNPs are removed. 

This function is prepared to run in parallel if the user registers a parallel structure, otherwise it runs sequentially.

This function also cleans up the sample names, converting them to the 12 digit format.
}
\examples{
\dontrun{
# Get data for ovarian cancer
cancerSite <- "OV"
targetDirectory <- paste0(getwd(), "/")
GetData(cancerSite, targetDirectory)

# Optional register cluster to run in parallel
library(doParallel)
cl <- makeCluster(5)
registerDoParallel(cl)

cancerSite <- "OV"
targetDirectory <- paste0(getwd(), "/")
GetData(cancerSite, targetDirectory)

stopCluster(cl)
}

}
\keyword{cluster}
\keyword{download}
\keyword{preprocess}
