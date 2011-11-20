# -*- coding: cp932 -*-
require 'csv'
list = {}
std = Hash.new
prev_word = nil
File.foreach('words') do |lin|
  lin2 = lin.gsub(/《.*?》/, "")
  lina = (CSV.parse(lin2))[0]
  nm = nil
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

    else
      nm = nil
    end
    if klsn then
      list[nm] = [sz, klsn.inspect]
    end

    if prev_word and nm then
      std[prev_word] ||= Hash.new(0)
      std[prev_word][nm] += 1
    end
    prev_word = nm
  end
end

print "# -*- coding: cp932 -*-\n"
print "WORD_TABLE = {\n"

list.each do |nm, rest|
  print "'#{nm}' => [ #{rest.join(',')}], \n"
end
print "}\n"

std.each do |w0, w1list|
  w1list.each do |w1, weight|
    print("study('#{w0}', '#{w1}', #{weight})\n")
  end
end
