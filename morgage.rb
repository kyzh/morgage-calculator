#!/usr/bin/env ruby
require 'rubygems'
require 'slop'

# Morgage calculator
# Source : https://github.com/kyzh/morgage-calculator
# License: WTFPL
#
# Main variable for a fixed morgage:
# principal = property of the loan
# interest = annual interest rate (percent) 
# length = length of the loan or at least the length over which the loan is amortized. (in years)
# monthly_interest = monthly interest in decimal form : interest / (12 x 100)
# amortisment_length = months over which loan is amortized : length x 12

class Morgage
  def initialize (p,d,i,l,c,s,v)
    @property           = p # opts[:a]     # Property value
    @deposit_rate       = d
    @deposit            = @property * (d/100.to_f) # opts[:d] # Deposit value computed from percentage required by lender.
    @principal          = @property - @deposit      # Morgage sum, what will be borrowed from lender
    @interest           = i # opts[:i]     # Annual interest rate that are charge on the sum left to pay  
    @length             = l # opts[:l]     # Morgage lenght in year
    @loan_balance       = @principal
    @amortisment_length = @length * 12     # Morgage lenght in month
    @conveyancing       = c                # Money spent on conveyancing http://www.theadvisory.co.uk/conveyancing-quote.php
    #base is between £300 - £1,200, then fees can add between 250 and 1300, then not to forget VAT on the base and some fees.
    @survey             = s                # At least a Basic Morgage Valuation will be required by the lender
    #Basic Mortgage Valuation 1‰ of the property + charge.
    #Homebuyer's Survey 2.5‰ of the property + arrangement fee
    #Building Survey 6‰ + charge. Everything needs VAT.
    @monthly_interest   = 0 
    @stamp_duty         = 0 
    @monthly_repayment  = 0
    @interest_paid      = 0
    @capital_paid       = 0
    @upfront_paid       = 0
    @overall_spending   = 0
    @overall_cost       = 0 
    @depreciation       = 0
    @depreciation_rate  = 27.5
    @appreciation       = 0
    @appreciation_rate  = 27.5
    @repaiments         = []
  end

  def printout
    puts "Considering a #{@property} property with #{@deposit_rate} %  deposit."
    puts "Considering a #{@length} years long morgage with a #{@interest} APR interest"
    puts ""
    puts "The amount towards deposit:       #{@deposit}"
    puts "The amount borrowed:              #{@principal}"
    puts ""
    puts "Iterest cost:                     #{@interest_paid.round}"
    puts "Stamp duty cost:                  #{@stamp_duty}"
    puts "Survey cost:                      #{@survey}"
    puts "Conveyancing cost:                #{@conveyancing}"
    puts "Total cost:                       #{@overall_cost.round}"
    puts ""
    puts "Overall budget:                   #{@overall_spending.round}"
    puts "Upfront requirement:              #{@upfront_paid}"
    puts ""
    puts "Monthly breakdown:"
    @repaiments.each{|repaiment| puts "Month #{repaiment["month"]}: capital: #{repaiment["capital"].round} interest: #{repaiment["interest"].round} repaiment #{(repaiment["capital"] + repaiment["interest"]).round}) balance : #{repaiment["balance"].round}"}
    #puts "#{current_month} : repayment is #{@monthly_repayment.round} ( #{monthly_capital.round} #{monthly_interest.round}) balance : #{@loan_balance.round}"
  end

  def compute_loan
    @monthly_interest   = (@interest / (12 * 100)).round(6)
    @monthly_repayment  = @principal * ( @monthly_interest / (1 - (1 + @monthly_interest) ** -@amortisment_length))
    @amortisment_length.times do |m|
      @repaiments << {"month" => m ,"interest"=> @loan_balance * @monthly_interest, "capital"=> @monthly_repayment - @loan_balance * @monthly_interest, "balance" => @loan_balance - @monthly_repayment}
      @loan_balance -= @monthly_repayment - @loan_balance * @monthly_interest
    end
    @capital_paid     = @repaiments.collect{|m| m["capital"]}.inject(:+)
    @interest_paid    = @repaiments.collect{|m| m["interest"]}.inject(:+)
    @upfront_paid     = @deposit       + @stamp_duty + @survey + @conveyancing
    @overall_cost     = @interest_paid + @stamp_duty + @survey + @conveyancing
    @overall_spending = @interest_paid + @stamp_duty + @survey + @conveyancing +  @property
  end

  def appreciation_depreciation
    @appreciation = (@property * @appreciation_rate) * @length
    @depreciation = ((@property / @depreciation_rate) * @length).round(2)
  end

  def stamp
    @stamp_duty = case @property
      when 0..125000 then 0
      when 125001..250000 then @property * 0.01
      when 250001..500000 then @property * 0.03
      when 500001..1000000 then @property * 0.04
      when 1000001..2000000 then @property * 0.05
      else @property * 0.07
    end
  end

  def start
    compute_loan
    appreciation_depreciation
    stamp
    printout
  end 

end

opts = Slop.parse do
  banner "ruby rate.rb [options]l\n"
  on :p=, :property, :as => :int
  on :d=, :deposit, :as => :int
  on :i=, :interest, :as => :int
  on :l=, :length, :as => :int
  on :v=, :value, :as => :int
  on :f=, :furnishing, :as => :int
  on :c=, :conveyancing, :as => :int
  on :s=, :survey, :as => :int
end

Morgage.new((opts[:p].to_i), opts[:d].to_f, opts[:i].to_f, opts[:l].to_i, opts[:c].to_i, opts[:s].to_i, opts[:v].to_i).start
