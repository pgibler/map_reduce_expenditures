# Map Reduce our monthly expenditures.

require 'date'

# Drop the first line because its just column names.
daily_expenditures = File.readlines('AccountHistory.csv').drop(1).map do |line|
  
  account_number, post_date, check, description, debit, credit, status, balance = line.split(',')
  
  # Return an object with the total spent for that day.
  {
    # The month this day happened in.
    month: Date.strptime(post_date, '%m/%d/%Y').month,
    
    # How much was spent in total.
    spent: debit.to_f
  }
end

# Reduce our monthly expenditures and tally the total up.
# Initialize the reduce call with an empty hash that can be populated with month -> monthly_expenditures key/value pairs.
monthly_expenditures = daily_expenditures.reduce({}) do |memo, daily_expenditure|
  # Get our month & amount values.
  month = daily_expenditure[:month]
  spent = daily_expenditure[:spent]
  
  # Initialize the monthly total to zero.
  if(!memo.key? month)
    memo[month] = 0
  end

  # Add the new daily expenditure amount to the monthly total.
  memo[month] += spent
  
  # Return the memo hash.
  memo
end

# Output the numbers.
monthly_expenditures.each_pair do |k,v|
  puts "#{Date::MONTHNAMES[k]} - $#{v.round(2)}"
end