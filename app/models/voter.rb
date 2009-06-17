require 'mechanize'

class Voter
  PEOPLE = [
            %w[ Ryan Walker ry@anotherventure.com ],
            %w[ Bill Barnett bill@budgetsketch.com ],
            %w[ Michael Guterl mguterl@gmail.com ],
            %w[ Rene Barnett rene.barnett@gmail.com ],
            %w[ Sandy Lea scripsafe@gmail.com ],
            %w[ Rob Biedenharn Rob@AgileConsultingLLC.com ],
            %w[ Polly Barnett polly@polly-barnett.com ],
            %w[ James Smith st23am@gmail.com ],
            %w[ Paul Visscher paulv@canonical.org ],
            %w{Chris Nelson me@christophernelsonconsulting.com}
           ]

  def self.execute
    PEOPLE.each do |person|
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
