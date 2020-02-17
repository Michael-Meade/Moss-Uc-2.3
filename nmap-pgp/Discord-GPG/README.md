# Discord-GPG

# What does it do?
Users upload their gpg key to the bot. When the user uses the [b].btcgen[/b] command, the bot will create a random bitcoin address. The bot than uses the user's public key to encrypt the bitcoin wallet information, then it sends the gpg encrypted file to the discord channel. I tired to make it as secure as possible. The newly created bitcoin address is not written to file until the information is encrypted with the user's public key. This ensures that the bot owner and the users in the discord can't read the sensitive information. The bot owner could always modify the code but there is really no point because this projet is pretty useless. I just wanted to mess around and learn more about gpg. I wrote a small wrapper for gpg (Linux) that is able to import the user's public key into the keyring, encrypt the messages and sign messages. 


# Generating the bitcoin address.
Last year I modified https://bhelx.simst.im/articles/generating-bitcoin-keys-from-scratch-with-ruby/ some of the code used in that link to create a vanity bitcoin address. I re used and modifiedd some of the code from that project to create the bitcoin address.





  
