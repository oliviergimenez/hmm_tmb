library(TMB)
compile("multievent_tmb.cpp")
dyn.load(dynlib("multievent_tmb"))

# read in data
data = read.table('titis2.txt')

# define various quantities
nh <- dim(data)[1]
k <- dim(data)[2]
km1 <- k-1

# counts
eff <- rep(1,nh)
  
# compute the date of first capture fc, and state at initial capture init.state
fc <- NULL
init.state <- NULL
for (i in 1:nh){
  temp <- 1:k
  fc <- c(fc,min(which(data[i,]!=0)))
  init.state <- c(init.state,data[i,fc[i]])
}

# init values
binit <- runif(9)
  
# transpose data
data <- t(data)

f <- MakeADFun(
  data = list(ch = data, fc = fc, fs = init.state), 
  parameters = list(b = binit),
  DLL = "multievent_tmb")
#opt <- do.call("optim", obj)
f$fn(binit)
f$report()$B 
f$report()$BE 
f$report()$A
f$report()$PROP

#rep <- sdreport(f)
#rep

