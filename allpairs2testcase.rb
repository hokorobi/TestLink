# allpair2testcase
# allpair -> testcase converter
# 
# 2007/09/29 0.00 garyo release 
# 2007/10/01 0.01 garyo release テストケース名を変更できるよう変更
# 2007/10/01 0.02 garyo テストケースが２回登録される不具合修正

#! /usr/local/bin/ruby

require 'kconv'
require 'csv2testcace'

class ApTestcase
  attr_accessor :items,:testcase,:expectedResult
  @items
  @testcase
  @expectedResult
  @@t = 0
  def initialize
    @items=[]
    @testcase = []
    @expectedResult = ""
  end
  def print
    s="<TABLE>"
    for i in 0..@items.size-1
      s=s + "<TR>"
      s=s+"<TD>#{@items[i].split}</TD>"
      s=s+"<TD>#{@testcase[i].split}</TD>"
      s=s + "</TR>"
    end
    s=s + "</TABLE>"
  end
  def getTitle
    @@t = @@t + 1
    @@t.to_s
  end
end
class AllpairsTestcase
  attr_accessor :testcase
  @testcase
  def initialize
    @testcase=[]
  end
end

class Allpairs2Testcase
  attr_accessor :allpairsTestcase
  @allpairsTestcase
  @csv2testcase
  @details
  @summary
  def initialize
    @allpairsTestcase=AllpairsTestcase.new
    @csv2testcase=Csv2testcase.new
    @details=""
    @summary=""
  end
  def readFile(infile)
    f = File.open(infile,"r")
    # get a label line
    s=f.gets
    #puts Kconv.kconv(s, Kconv::SJIS, in_code = Kconv::EUC)
    items=s.split("\t")
    useExpRes = false
    if items.last.chomp == "ExpectedResult" then
      items.pop
      useExpRes = true
    end
    s=f.gets
    while s !=nil
      tc=ApTestcase.new
      tc.items=items
      #puts Kconv.kconv(s, Kconv::SJIS, in_code = Kconv::EUC)
      t=s.split("\t")
      tc.expectedResult = t.pop if useExpRes
      tc.testcase = t
      @allpairsTestcase.testcase << tc
      s=f.gets
    end

  end
  def initTestSuite(name,details)
    @csv2testcase.initTestSuite(name,details)
  end
  def convXML(name_prefix="Test case No.",summary_prefix=@summary,steps_prefix="",expectedresults_prefix="")
    @allpairsTestcase.testcase.each{|tc|
      @csv2testcase.addTestcase(name_prefix + tc.getTitle,summary_prefix,steps_prefix + tc.print,expectedresults_prefix + tc.expectedResult)
    }
  end
  def writeFile(outfile)
    @csv2testcase.writeFile(outfile)
  end
  def main(infile,outfile)
    readFile(infile)
    initTestSuite(infile,@details)
    convXML
    writeFile(outfile)
  end
end

if ARGV.size != 2 then
  puts "usage allpairs2testcase.rb infile outfile"
else
  c=Allpairs2Testcase.new
  c.main(ARGV[0],ARGV[1])
end
