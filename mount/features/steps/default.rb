When(/^I run the bash command:$/) do |string|
  run_simple("bash -c '#{string}'", false)
end
