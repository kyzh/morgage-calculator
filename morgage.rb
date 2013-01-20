#!/usr/bin/env ruby
require 'rubygems'
require 'slop'

# Morgage calculator
# Source : https://github.com/kyzh/morgage-calculator
# License: WTFPL
#
# Main variable for a fixed morgage:
# principal = amount of the loan
# interest = annual interest rate (percent) 
# length = length of the loan or at least the length over which the loan is amortized. (in years)
# monthly_interest = monthly interest in decimal form : interest / (12 x 100)
# amortisment_length = months over which loan is amortized : length x 12

class Morgage
  def initialize (a,d,i,l,v)
    @amount             = a # opts[:a].to_i
    @deposit            = d # opts[:d].to_f
    @principal          = a * (1 - d)
    @interest           = i # opts[:i].to_i
    @length             = l # opts[:l].to_i
    @monthly_interest   = i / (12 * 100)
    @amortisment_length = l * 12
    @added_value        = v
    @loan_balance       = @principal
    @monthly_repayment  = @principal * ( @monthly_interest / (1 - (1 + @monthly_interest) ** -@amortisment_length))
    @interest_paid      = 0
    @capital_paid       = 0
    @depreciation_pm    = 0
    @depreciation       = 27.5
  end

  def header
    puts "For a #{@amount} property with #{@deposit * 100} percent deposit, the loan is #{@principal}"
    puts "Considering #{@length} years with a #{@interest} APR interest"
    puts ""
  end

  def footer
    puts "For a capital of #{@capital_paid}, the total interest is #{@interest_paid} "
  end

  def compute
    # loan_balance = @principal
    current_month = 1
    while current_month  < @amortisment_length + 1 do
      monthly_interest  = @loan_balance      * @monthly_interest
      monthly_capital   = @monthly_repayment - monthly_interest
      @interest_paid    = @interest_paid     + monthly_interest
      @capital_paid     = @capital_paid      + monthly_capital 
      @loan_balance     = @loan_balance      - monthly_capital
      puts "#{current_month} : repayment is #{@monthly_repayment.truncate} ( #{monthly_capital.truncate} #{monthly_interest.truncate}) balance : #{@loan_balance.truncate}"
      current_month = current_month + 1
    end
  end

  def start
    header
    compute
    footer
  end 

end

opts = Slop.parse do
  banner "ruby rate.rb [options]l\n"
  on :a=, :amount, :as => :int
  on :d=, :deposit, :as => :int
  on :i=, :interest, :as => :int
  on :l=, :length, :as => :int
  on :v=, :value, :as => :int
  on :f=, :furnishing, :as => :int
end

Morgage.new((opts[:a].to_i), opts[:d].to_f, opts[:i].to_f, opts[:l].to_i, opts[:v].to_i).start
