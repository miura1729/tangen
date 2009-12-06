# -*- coding: cp932 -*-

require 'words.rb'

class KlassWListTable
  def initialize
    @table = []
    (1..20).each do |n|
      @table[n] = Array.new
    end
  end

  def add(word, n)
    @table[n].push word
  end

  def get_word(n)
    wlist = @table[n]
    lsiz = wlist.size
    if lsiz == 0 then
      nil
    else
      wlist[rand(lsiz)]
    end
  end
end

class Word
  def initiailize(word, size, klass)
    @size = size
    @word = word
    @klass = klass
  end

  def get_word(n)
    if @size == n then
      @word
    else
      nil
    end
  end
end

KlassPos = {:Noum => 0, :Verb => 1, :Adj => 2, :Postp => 3}

Klasses = {
  :Noum => KlassWListTable.new,
  :Verb => KlassWListTable.new,
  :Adj => KlassWListTable.new,
  :Postp => KlassWListTable.new,
}

class TranslateTable
  TranslateKlassInit = [
    # :Noum, :Verb, :Adj, :Postp
      [1,      3,    1,     5],    # Noum
      [5,      1,    5,     0],    # Verb
      [5,      1,    1,     1],    # Adj
      [5,      3,    5,     1],    # Postp
  ]
  
  def initialize(word)
    @word = word
    @klass = WORD_TABLE[word][1]
    @table = {}
    @total = 0
    Klasses.each do |tokl, tab|
      fmpos = KlassPos[@klass]
      topos = KlassPos[tokl]
      n = TranslateKlassInit[fmpos][topos]
      @table[tab] = n
      @total += n
    end
  end
  
  def add(w_or_tab, weight = 1) 
    @total += weight
    @table[w_or_tab] = weight
  end

  def study(toword, val)
    toklnm = WORD_TABLE[toword][1]
    toklass = Klasses[toklnm]

    w = @table[toklass]
    w0 = w + val
    if w0 < 0 then
      w0 = 0
    end
    @total += (w0 - w)
    @table[toklass] = w0
  end
  
  def get_next_word(n)
    wc = 0
    @table.each do |wot, weight|
      wc += weight
      if rand(@total) <= wc then
        wd = wot.get_word(n)
        if wd then
          return wd
        end
      end
    end
    raise "Internal error maybe bugs"
  end
end

class TankaGen
  def initialize
    @translate_table = {}
    WORD_TABLE.each do |word, attr|
      size = attr[0]
      klass = attr[1]
      Klasses[klass].add(word, size)
      @translate_table[word] = TranslateTable.new(word)
    end
  end
  
  def gen_ku(n)
    prev_word = nil
    result = ""
    rest = n
    while rest > 0 do
      clen = 0
      word = nil
      begin
        clen = rand(rest) + 1
        if prev_word then
          word = @translate_table[prev_word].get_next_word(clen)
        else
          word = Klasses[:Noum].get_word(clen)
        end
      end until word 
      prev_word = word
      result += word
      rest -= clen
    end
    
    result
  end
end

print TankaGen.new.gen_ku(10)
