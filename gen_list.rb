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
    when /名詞/
      klsn = :Noum
    when /動詞/
      klsn = :Verb
    when /助詞/
      klsn = :Postp
    when /形容詞/
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

