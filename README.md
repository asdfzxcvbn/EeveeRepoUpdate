# EeveeRepoUpdate
nim script to update EeveeSpotify's repo, on my profile because i want to boost the nim percentage shit on my profile :P

## compilation
install [nim](https://nim-lang.org/install_unix.html)

`nim c -d:release -d:ssl --opt:speed --cpu:amd64 --os:linux eeveeRepo.nim`

## usage
must have repo.json in your working dir, and it must have "apps" array defined

then just call the built executable lol
