require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe WaterPark do
  before :each do 
    begin
      s = TCPSocket.new("127.0.0.1", "11222")
      s.close
      socket_open = true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      socket_open = false
    end

    if !socket_open
      @tcp_server = TCPServer.new(11222)
      @udp_server = UDPSocket.new
      @udp_server.bind(nil, 11223)
    end
  end

  after :each do
    @tcp_server.close if defined?(@tcp_server)
    @udp_server.close if defined?(@udp_server)
  end

  describe "when in a empty WaterPark" do  
    subject{ WaterPark.new }

    specify{ subject.get_all_pools.size.should eq(0) }
    specify{ subject.get_pool("hello").should be_nil }
    specify{ subject.remove_pool("none").should be_nil }
    specify{ subject.close.should be_true }
  end

  describe "when adding a single pool" do 
    subject{ WaterPark.new }

    it "#add_pool" do 
      subject.add_pool(:pool1, '127.0.0.1', '11222')
      subject.get_all_pools.size.should eq(1)
    end

    context "when pool key already exists" do 
      it "should only have 1 pool" do 
        subject.add_pool(:pool1, '127.0.0.1', '11222')
        subject.get_all_pools.size.should eq(1)

        subject.add_pool(:pool1, '127.0.0.1', '11220')
        subject.get_all_pools.size.should eq(1)
      end

      it "should overwrite the pool options with the newest pool" do 
        subject.add_pool(:pool1, '127.0.0.1', '11222')
        subject.add_pool(:pool1, '127.0.0.1', '22211')

        subject.get_pool(:pool1).port.should eq('22211')
        subject.get_all_pools.size.should eq(1)
      end
    end
  end
end
