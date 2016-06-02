
### How do we check the type I error and power for a two-sample t-test?
### This function simulates the pvalue
sim.check.power=function(n,mu0,mu1,sigma)
{
    # simulate the first sample from N[mu0,sigma]
    x0=rnorm(n,mu0,sigma)
    # simulate the second sample from N[mu1,sigma]
    # Note that the two distributions only differ in the means
    x1=rnorm(n,mu1,sigma)
    # extract the P-value for the two-sample t-test
    t.test(x0,x1)$p.value
}

set.seed(123321)
B=10000

### Empirically Check type I error (mu0=mu1=1;sigma=5)
### Note that power-alpha when mu0=mu1
### The power of rejecting H0 when H0 is true is alpha!
pvals=replicate(B,sim.check.power(n=3,mu0=1,mu1=1,sigma=5))
mean(pvals<0.05)
pvals=replicate(B,sim.check.power(n=6,mu0=1,mu1=1,sigma=10))
mean(pvals<0.05)
pvals=replicate(B,sim.check.power(n=12,mu0=1,mu1=1,sigma=10))
mean(pvals<0.05)
            

### For the power calculations use the asymptotic formula
### power.t.test and use simulations

### Calculate power (mu0=0 mu1=2;sigma=5) |0-2]/5=0.4
power.t.test(n=3,delta=abs(2-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=3,mu0=0,mu1=2,sigma=5))
mean(pvals<0.05)

power.t.test(n=6,delta=abs(2-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=6,mu0=0,mu1=2,sigma=5))
mean(pvals<0.05)

power.t.test(n=12,delta=abs(2-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=12,mu0=0,mu1=2,sigma=5))
mean(pvals<0.05)


### The point of this exercise is to show that increasing the effect
### size increases the power
### Calculate  power (mu0=0 mu1=3;sigma=5) effect size is |0-3]/5=0.75
power.t.test(n=3,delta=abs(3-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=3,mu0=0,mu1=3,sigma=5))
mean(pvals<0.05)

power.t.test(n=6,delta=abs(3-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=6,mu0=0,mu1=3,sigma=5))
mean(pvals<0.05)

power.t.test(n=12,delta=abs(3-0),sd=5,sig.level=0.05)
pvals=replicate(B,sim.check.power(n=12,mu0=0,mu1=3,sigma=5))
mean(pvals<0.05)

### Calculate power (mu0=0 mu1=3;sigma=7.5) effect size is |0-3]/1=7.5
### Note that the effect of increasing the standard deviation
### will effectively reduce the effect size to that of the first
### example
### In other words: The power is a function of |mu0-mu1|/sigma
### and note the individual parameters
pvals=replicate(B,sim.check.power(n=3,mu0=0,mu1=3,sigma=7.5))
mean(pvals<0.05)
pvals=replicate(B,sim.check.power(n=6,mu0=0,mu1=3,sigma=7.5))
mean(pvals<0.05)
pvals=replicate(B,sim.check.power(n=12,mu0=0,mu1=3,sigma=7.5))
mean(pvals<0.05)


### What should the sample size be if we wish to have a power
### of 0.8 at the 0.05 level assuming that (mu0=0 mu1=2;sigma=5)?

scalc=power.t.test(delta=abs(2-0),sd=5,sig.level=0.05,power=0.8)
# Extract sample size
scalc$n
# This not an integer so
N=ceiling(scalc$n)
N
## Now check the power based on this sample size
pvals=replicate(B,sim.check.power(n=N,mu0=0,mu1=2,sigma=5))
mean(pvals<0.05)


### This is optional. 

sample.size.ttest=function(alpha,power,mu0,mu1,sigma)
    {
        # The effect size is  |mu0-mu1|/sigma
        delta=abs(mu0-mu1)/sigma
        numerator=2*(qnorm(power)+qnorm(1-alpha/2))^2
        denominator=(delta)^2
        n=numerator/denominator
        # may not be an integer
        n=ceiling(n)
        return(n)
    }
        
N=sample.size.ttest(0.05,0.8,0,2,5)
N # This is PER group

## Now check the power based on this sample size
pvals=replicate(B,sim.check.power(n=N,mu0=0,mu1=2,sigma=5))
mean(pvals<0.05)


