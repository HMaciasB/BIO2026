
# Pipeline de análisis de secuenciación de ADN 

# Usaremos como ejemplo una secuenciación Illumina de un genoma bacteriano pequeño.

#-------------------------
#ACTUALIZAR
#-------------------------
#sudo apt update
#sudo apt upgrade -y

#-------------------------
#Instalar programas
#-------------------------
#sudo apt install -y \
 #build-essential \
 #unzip zip \
 #python3 python3-pip \
  #openjdk-11-jre

#--------------------------------------
#Instalar programas bioinformática
#--------------------------------------
#sudo apt install -y \
 #fastqc \
  #trimmomatic \
  #spades \
  #busco 

#---------------------------
#Verificar Instalación
#---------------------------
fastqc --version
spades.py --version
busco --version
java -jar /usr/share/java/trimmomatic.jar -version

#---------------------------------------------------------
# Descarga de datos de secuenciación:
#---------------------------------------------------------

mkdir genome

cd genome

ls ./

#------------------
#Shigella sonnei
#------------------

#curl -L -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR024/ERR024070/ERR024070_1.fastq.gz
#curl -L -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR024/ERR024070/ERR024070_2.fastq.gz

#-----------------
#E.coli
#-----------------

#curl -L -o genoma1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR259/003/ERR2597663/ERR2597663_1.fastq.gz
#curl -L -o genoma2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR259/003/ERR2597663/ERR2597663_2.fastq.gz

#----------------------
# Salmonella enterica
#----------------------

#curl -L -o genoma1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR275/007/ERR2756787/ERR2756787_1.fastq.gz
#curl -L -o genoma2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR275/007/ERR2756787/ERR2756787_2.fastq.gz

#--------------------
# Bacillus subtilis
#--------------------
curl -L -o genoma1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR162/009/ERR1620359/ERR1620359_1.fastq.gz
curl -L -o genoma2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR162/009/ERR1620359/ERR1620359_2.fastq.gz

#--------------------------------------------------------
# VER LA CALIDAD DE LA SECUENCIACIÓN CON FASTQC
#--------------------------------------------------------

#mkdir fastqc

#fastqc genoma1.fastq.gz genoma2.fastq.gz -o fastqc/

#---------------------------------------------------------
# Filtrado/Limpieza de lecturas crudas con TRIMMOMATIC
#-----------------------------------------------------------

mkdir trimmomatic_clean/

java -jar /usr/share/java/trimmomatic.jar PE -threads 4 -phred33 genoma1.fastq.gz genoma2.fastq.gz trimmomatic_clean/ERR024070_1.paired.fq.gz trimmomatic_clean/ERR024070_1.unpaired.fq.gz trimmomatic_clean/ERR024070_2.paired.fq.gz trimmomatic_clean/ERR024070_2.unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#---------------------------------------------------------
# VERIFICAR LIMPIEZA CON FASTQC
#---------------------------------------------------------

#mkdir fastqc_clean

#fastqc trimmomatic_clean/ERR024070_1.paired.fq.gz trimmomatic_clean/ERR024070_2.paired.fq.gz -o fastqc_clean/

#----------------------------------------------------------
#ENSAMBLAR UN GENOMA CON SPADES. (t) es el número de núcleos, y (m) es la cantidad de memoria RAM, ambos valores se pueden modificar
#----------------------------------------------------------

mkdir results_spades/

spades.py --isolate -1 trimmomatic_clean/ERR024070_1.paired.fq.gz -2 trimmomatic_clean/ERR024070_2.paired.fq.gz -o results_spades -t 4 -m 8

#----------------------------------------------------------
#VER LA CALIDAD DEL ENSAMBLADO UTILIZANDO BUSCO:
#----------------------------------------------------------

busco -i results_spades/contigs.fasta -o busco_out -l bacteria_odb10 -m genome


