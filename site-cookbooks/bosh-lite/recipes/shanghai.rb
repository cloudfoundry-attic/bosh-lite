execute "change gem source to TaoBao" do
  command  "gem sources --remove http://rubygems.org/ && gem sources -a http://ruby.taobao.org/"
end
