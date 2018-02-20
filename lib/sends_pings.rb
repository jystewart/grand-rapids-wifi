# Copyright (c) 2007 James Stewart
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module KetLai
  module SendsPings
      # Specify sends_pings if you want creating of a model to notify various
      # hosts using the xml-rpc weblog ping system.
      #   class Story < ActiveRecord::Base
      #     sends_pings
      #   end
      #
    def self.included(mod)
      mod.extend(ClassMethods)
      mod.class_attribute :hosts_to_ping
    end

    module ClassMethods
      # == Configuration options
      #
      # By default sends_pings will ping rpc.pingomatic.com as it is a centralised
      # ping clearing house. To specify others you can use:
      #
      #   class Story < ActiveRecord::Base
      #     sends_pings :to => ['my.other.ping.com', 'this.ping.server']
      #   end
      #
      def sends_pings(args = {})

        include KetLai::SendsPings::InstanceMethods

        if args.has_key?(:to) and ! args[:to].empty?
          self.hosts_to_ping = args[:to]
        else
          self.hosts_to_ping = ['rpc.pingomatic.com']
        end

        class_eval do
          after_create :send_pings
        end
      end
    end

    module InstanceMethods
      # @todo   generate url properly
      def send_pings
        url = "http://grwifi.net/#{self.class.to_s.downcase}/#{self.to_param}"
        name = "#{SITE_NAME} #{self.class}: #{self.title}"
        self.class.hosts_to_ping.each do |host|
          send_ping(host, name, url)
        end
      end

      def send_ping(service, name, url)
        Timeout::timeout(30) do
          server = XMLRPC::Client.new2(service.endpoint)
          result = server.call('weblogUpdates.ping', name, url)
          Ping.create(:pingable => self, :notifiable_id => read_inheritable_array(:hosts_to_ping).index(service))
        end
      rescue
        return
      end
    end
  end
end
