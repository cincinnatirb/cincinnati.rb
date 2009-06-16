class Voter
require 'mechanize'

  PEOPLE = [
    ['Ryan','Walker','ry@anotherventure.com'],
    ['Michael','Guterl','mguterl@gmail.com'],
    ['Rene','Barnett','rene.barnett@gmail.com'],
    ]

  def self.execute
    a = WWW::Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://cincinnatiinnovates.com/contest/vote_form/25') do |page|
      PEOPLE.each do |person|
        vote_result = page.form_with(:name => 'vote_form') do |form|
          form['vote[first_name]'] = person[0]
          form['vote[last_name]'] = person[1]
          form['vote[email_confirmation]'] = form['vote[email]'] = person[2]
        end.submit
      end
    end
  end

end
