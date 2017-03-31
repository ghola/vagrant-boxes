yum -y install R

wget https://cran.r-project.org/src/contrib/Archive/Rcpp/Rcpp_0.12.9.tar.gz
/usr/bin/R CMD INSTALL Rcpp_0.12.9.tar.gz

wget https://cran.r-project.org/src/contrib/Archive/RcppArmadillo/RcppArmadillo_0.5.600.2.0.tar.gz
/usr/bin/R CMD INSTALL RcppArmadillo_0.5.600.2.0.tar.gz

wget https://rforge.net/Rserve/snapshot/Rserve_1.8-5.tar.gz
/usr/bin/R CMD INSTALL Rserve_1.8-5.tar.gz

rm -rf *.tar.gz

cat > install-forecast.r << EOM
install.packages("forecast", repos="https://cran.uni-muenster.de/")
EOM

/usr/bin/R -f install-forecast.r

rm -rf install-forecast.r

cat > /etc/Rserv.conf << EOM
remote disable
port 6311
EOM

cat > /home/vagrant/rserve.r << EOM
library(Rserve)
library("forecast")
run.Rserve(config.file = "/etc/Rserv.conf")
EOM
