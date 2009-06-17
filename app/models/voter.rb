require 'mechanize'

class Voter
  PEOPLE = [
            ['Ryan','Walker','ry@anotherventure.com'],
            ['Michael','Guterl','mguterl@gmail..com'],
            ['Rene','Barnett','rene.barnett@gmail.com'],
            %w[ Rob Biedenharn Rob@AgileConsultingLLC.com ],
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
          puts "vote_result is a #{vote_result.class.name}"
          puts vote_result.body
          puts (vote_result.search('//h2[@class="alreadyVoted"]') ?
                "%s %s <%s> has already voted" : "%s %s <%s> will be sent a vote confirmation!")%[*person]
      end
    end
  end

  private
  def get_agent
    case rand(100)
      when 0..30 then 'Windows IE 6'
      when 31..50 then 'Windows IE 7'
      when 51..65 then 'Windows Mozilla'
      when 66..80 then 'Mac Safari'
      when 81..90 then 'Mac Firefox'
      when 95..99 then 'Mac Mozilla'
    end
  end

end
