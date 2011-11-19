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
      case lina[1]
      when /非自立/
        klsn = :Noum_Hijiritu
      end

    when /動詞/
      klsn = :Verb
      case lina[1]
      when /非自立/
        klsn = :Verb_Hijiritu
      end

    when /助詞/
      klsn = :Postp

    when /形容詞/
      klsn = :Adj
      case lina[1]
      when /非自立/
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

