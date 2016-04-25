require 'rspec/expectations'

module Matchers
  extend RSpec::Matchers::DSL

  matcher :be_just_like_stanley_kubrick do |expected|
    match {|actual| actual == expected}
  end
end