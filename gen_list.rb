# -*- coding: cp932 -*-
require 'csv'
list = {}
File.foreach('words') do |lin|
  lina = (CSV.parse(lin))[0]
  if lina[7] then
    nm, klass = lina[0].split(/\t/)
    sz = lina[7].size
    klsn = nil
    case klass
    when /����/
      klsn = :Noum
    when /����/
      klsn = :Verb
    when /����/
      klsn = :Postp
    when /�`�e��/
      klsn = :Adj
    end
    if klsn then
      list[nm] = [sz, klsn.inspect]
    end
  end
end

list.each do |nm, rest|
  print "'#{nm}' => [ #{rest.join(',')}], \n"
end

