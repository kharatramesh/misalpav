FROM ubuntu
MAINTAINER "trainer@gmail.com"
LABEL "purpose"="this is webserver image, developed with apache2 webserver , works on port 80"
LABEL "customer"="ibm"
WORKDIR /samosa/idli
WORKDIR vadapav
RUN useradd -m app1
RUN apt update
RUN apt install apache2 -y && apt install tree -y && apt install net-tools -y && apt install iputils-ping -y && apt install vim -y &&  apt-get update &&  apt-get install -y wget apt-transport-https && wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb &&  dpkg -i packages-microsoft-prod.deb &&  rm packages-microsoft-prod.deb

RUN apt-get update
RUN apt-get install -y dotnet-sdk-8.0
COPY 1.txt /samosa
ADD 2.txt /samosa
COPY 1.tar /samosa/idli
ADD 1.tar /samosa/idli/vadapav
ADD https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.83-installer.msi /home
EXPOSE 80
VOLUME v1
ENV dbpasswd=123
ENV a=10
ARG dbconnection=db1.samosa.com
ARG b=20

# USER app1

COPY index.html /var/www/html
CMD ["apache2ctl","-D","FOREGROUND"]
