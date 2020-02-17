require 'open3'
class GPG
	def self.import_publickey(pubkey)
		stdout, status = Open3.capture2("gpg --import #{pubkey}")
	end
	def self.encrypt(text_to_encrypt, pubkey_name)
		Commands.get_output("echo '#{text_to_encrypt}' | gpg  --encrypt -a -r '#{pubkey_name}' --always-trust")
	end
	def self.export_public(pubkey_name, filename=nil)
		if !filename.nil?
			Commands.get_output("gpg --armor --export #{pubkey_name} > #{filename}")
		else
			Commands.get_output("gpg --armor --export #{pubkey_name}")
		end
	end
	def self.sign(pubkey_name, pass, file)
		Commands.get_output("echo '#{pass}' | gpg --batch --yes --passphrase-fd 0 --local-user #{pubkey_name} --sign #{file}")
	end
end