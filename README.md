morgage-calculator
==================

A simple script to print a morgage detail from its main caracteristic

Exemple: 
--------
Let say that the morgage is for a property worth a 100 000.
In order to have a good rate, one usually have to pay an upfront between 10 and 40 percent of the property value, .
The rate is usually fixed or variable, so far only fixed rate are available.

With the short form:
  ```
  ./morgage.rb -p 100000 -d 20 -i 3.49 -l 5 -c 1000 -s 500
  Considering a 100000 property with 20.0 %  deposit.
  Considering a 5 years long morgage with a 3.49 APR interest
  
  The amount towards deposit:       20000.0
  The amount borrowed:              80000.0
  The amount of interest add:       7298
  
  The amount for stamp duty add :   0
  The amount for survey add:        500
  The amount for conveyancing add:  1000

  Upfront requirement:              21500.0
  All non capital cost:             8798
  Overall budget:                   10879
  ```


With a long form:
  ```
  ./morgage.rb --property 100000 --deposit 20 --interest 3.49 --length 5 --conveyancing 1000 --survey 500
  ```

Installation:
--------
One would need to install slop:
  ```
  gem install slop
  ```

Contribute:
--------
Clone, create a topic branch, ?, pull request.

