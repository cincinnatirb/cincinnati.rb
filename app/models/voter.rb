require 'mechanize'

class Voter
  PEOPLE = [
            ['Ryan','Walker','ry@anotherventure.com'],
            ['Michael','Guterl','mguterl@gmail..com'],
            ['Rene','Barnett','rene.barnett@gmail.com'],
            %w[ Rob Biedenharn Rob@AgileConsultingLLC.com ],
            %w[ James Smith st23am@gmail.com ],
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
        puts (vote_result.search('//h2[@class="alreadyVoted"]') ?
              "%s %s <%s> has already voted" : "%s %s <%s> will be sent a vote confirmation!")%[*person]
      end
    end
  end

end
