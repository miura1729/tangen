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
      case lina[1]
      when /�񎩗�/
        klsn = :Noum_Hijiritu
      end

    when /����/
      klsn = :Verb
      case lina[1]
      when /�񎩗�/
        klsn = :Verb_Hijiritu
      end

    when /����/
      klsn = :Postp

    when /�`�e��/
      klsn = :Adj
      case lina[1]
      when /�񎩗�/
        klsn = :Adj_Hijiritu
      end
    end
    if klsn then
      list[nm] = [sz, klsn.inspect]
    end
  end
end

print "# -*- coding: cp932 -*-\n"
print "WORD_TABLE = {\n"

list.each do |nm, rest|
  print "'#{nm}' => [ #{rest.join(',')}], \n"
end
print "}\n"

