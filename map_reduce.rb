# Map Reduce our monthly expenditures.

require 'date'

# Get the file to read in. Default to 'transactions.csv'.
first_arg = ARGV[0]

# If nothing was input or the -h flag was specified, output the usage message.
if(first_arg.nil? or first_arg == '-h')
  puts "Usage: map_reduce.rb [-h] <transaction_file>"
  exit(0)
end

# The first arg should be treated as a file at this point.
transaction_file = first_arg

# Return if the file does not exist.
unless(File.exist?(transaction_file))
  puts "The specified transaction file does not exist. Did you mean something else?"
  # Failed to execute properly.
  exit(1)
end

# Drop the first line because its just column names.
# Then iterate the lines and then create a object from each transaction that contains the month it occurred in and how much was spent on the transaction.
daily_expenditures = File.readlines(transaction_file).drop(1).map do |line|
  
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

# It ran successfully.
exit(0)