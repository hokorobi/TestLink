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
  attr_accessor :items,:testcase
  @items
  @testcase
  def initialize
    @items=[]
    @testcase = []
  end
  def print
    s="<TABLE>"
    s=s + "<TR>"
    for i in 0..@items.size-2
      s=s+"<TD>#{@items[i].split}</TD>"
    end
    s=s + "</TR>"
    s=s + "<TR>"
    for i in 0..@testcase.size-2
      s=s+"<TD>#{@testcase[i].split}</TD>"
    end
    s=s + "</TR>"
    s=s + "</TABLE>"
  end
  def getTitle
    t=@testcase[0]
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
  def initialize
    @allpairsTestcase=AllpairsTestcase.new
    @csv2testcase=Csv2testcase.new
  end
  def readFile(infile)
    f = File.open(infile,"r")
    s=f.gets
    s=f.gets
    s=f.gets
    items=s.split("\t")
    s=f.gets
    while s !="\n"
      tc=ApTestcase.new
      tc.items=items
      tc.testcase=s.split("\t")
      @allpairsTestcase.testcase << tc
      s=f.gets
    end

  end
	def initTestSuite(name,details)
    @csv2testcase.initTestSuite(name,details)
	end
  def convXML(name_prefix="Test case No.",summary_prefix="",steps_prefix="",expectedresults_prefix="")
    @allpairsTestcase.testcase.each{|tc|
      @csv2testcase.addTestcase(name_prefix + tc.getTitle,summary_prefix + tc.print,steps_prefix + tc.print,expectedresults_prefix)
    }
  end
  def writeFile(outfile)
    @csv2testcase.writeFile(outfile)
  end
  def main(infile,outfile)
		readFile(infile)
    initTestSuite(infile,"")
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
