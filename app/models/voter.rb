require 'mechanize'

class Voter
  PEOPLE = [
            ['Ryan','Walker','ry@anotherventure.com'],
            ['Michael','Guterl','mguterl@gmail..com'],
            %w[ Rob Biedenharn Rob@AgileConsultingLLC.com ],
           ]

  def self.execute
    a = WWW::Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://cincinnatiinnovates.com/contest/vote_form/25') do |page|
      PEOPLE.each do |person|
        vote_result = page.form_with(:name => 'vote_form') do |form|
          form['vote[first_name]'], form['vote[last_name]'], form['vote[email]'] = person
          form['vote[email_confirmation]'] = form['vote[email]']
        end.submit
        puts "vote_result is a #{vote_result.class.name}"
        puts vote_result.body
        if vote_result.search('//h2[@class="alreadyVoted"]')
          puts "%s %s <%s> has already voted"%[*person]
        end
      end
    end
  end

end
