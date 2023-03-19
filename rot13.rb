#!/usr/bin/ruby
#
require 'io/console'

def generate_rot13_mapping
  alphabet_range = ('a'..'z')
  rot13_shift = 13
  alphabet_size = alphabet_range.count

  return alphabet_range.to_h do |question|
    answer_ord = question.ord + rot13_shift
    if answer_ord > 'z'.ord
      answer_ord -= alphabet_size
    end
    [question, answer_ord.chr]
  end
end

def show_results(title, results)
  puts "#{title}:"
  results.each do |result| 
    time = 
    puts "#{result['question']} | #{result['answer_time_ms'].to_s.rjust(4, ' ')} ms"
  end
end

rot13_mapping = generate_rot13_mapping
results = []

puts "Starting quiz, type in ROT-13 translated letters. CTRL-C to exit."

while !rot13_mapping.empty?
  question = rot13_mapping.keys.sample
  answer = rot13_mapping[question]

  questions_left = "(#{rot13_mapping.size.to_s.rjust(2, ' ')} left)"

  question_time = Time.now.to_f
  while true
    print "#{questions_left} #{question} -> "

    input = STDIN.getch
    exit if input == "\u0018" or input == "\u0003"

    if input == answer
      answer_time = Time.now.to_f - question_time
      answer_time_ms = (1000 * answer_time).to_i
      puts "#{answer} OK"
      results << {'question' => "#{question} -> #{answer}", 'answer_time_ms' => answer_time_ms}
      rot13_mapping.delete(question)
      break
    else
      puts "#{input} WRONG, try again"
    end
  end
end

average = results.map { |result| result['answer_time_ms'] }.sum / results.size
puts "Average time: #{average} ms"

sorted_results = results.sort_by { |result| result['answer_time_ms'] }
show_top_count = 5

show_results("Best", sorted_results.first(show_top_count))
show_results("Worst", sorted_results.last(show_top_count).reverse)
