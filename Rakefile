# Rakefile to deploy changes from the master ...
# use: rake deploy 
PUPPETMASTER = 'localhost'
SSH = 'ssh -t -A'
USER = 'master'

task :deploy do
    sh "git push"
    sh "cd /etc/puppet && git pull"
    # sh "#{SSH} #{USER}@#{PUPPETMASTER} 'cd /etc/puppet && sudo git pull'"
end
