require 'mechanize'
require 'hpricot'

unless Array.instance_methods.include?(:random)
  class Array
    def random
      self[Kernel.rand(self.length)]
    end
  end
end

class Voter
  PEOPLE = [
            %w[ Ryan Walker ry@anotherventure.com ],
            %w[ Www Guru wwwguru@gmail.com ],
            %w[ Bill Barnett bill@budgetsketch.com ],
            %w[ Michael Guterl mguterl@gmail.com ],
            %w[ Rene Barnett rene.barnett@gmail.com ],
            %w[ Sandy Lea scripsafe@gmail.com ],
            %w[ Rob Biedenharn Rob@AgileConsultingLLC.com ],
            %w[ Polly Barnett polly@polly-barnett.com ],
            %w[ James Smith st23am@gmail.com ],
            %w[ Paul Visscher paulv@canonical.org ],
            %w[ Chris Nelson me@christophernelsonconsulting.com ],
            %w[ Mary Barnett-Dailey mdailey0506@cinci.rr.com ],
            %w[ Bill Spurling wlspurling@bspurling.com ],
            %w[ Mike Barnett mbarnett@ka-partners.com ],
            %w[ Mike Barnett mbarnett@smartcloudsw.com ],
            %w[ Mike Barnett mwbarnett@comcast.net ],
            %w[ Elizabeth Naramore elizabeth.naramore@gmail.com ],
            %w[ Gerard Sychay hellogerard@gmail.com ],
            %w[ Sherry Reiland mimireiland@fuse.net ],
           ]

  def self.execute
    PEOPLE.each do |person|
      WWW::Mechanize.html_parser = Hpricot
      a = WWW::Mechanize.new { |agent|
        agent.user_agent_alias = get_agent
      }

      a.get('http://cincinnatiinnovates.com/contest/vote_form/25') do |page|
        vote_result = page.form_with(:name => 'vote_form') do |form|
          form['vote[first_name]'], form['vote[last_name]'], form['vote[email]'] = person
          form['vote[email_confirmation]'] = form['vote[email]']
        end.submit
        puts (vote_result.search('//h2[@class="alreadyVoted"]') ?
              "%s %s <%s> has already voted" : "%s %s <%s> will be sent a vote confirmation!")%[*person]
      end
    end
  end

  private
  def self.get_agent
    WWW::Mechanize::AGENT_ALIASES.keys.random
  end

end
