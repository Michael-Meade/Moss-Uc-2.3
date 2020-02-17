require 'openssl'
require 'ecdsa'
require 'securerandom'
require 'base58'
require 'fileutils'
require 'colorize'
class File
  def self.save(info)
    f = File.open(File.join(info.to_a[0] + ".txt"), "a")
    info.each do |btc|
        f.write(btc + "\n\n")
    end
    f.close
  end
end
class BitcoinAddress
  ADDRESS_VERSION = '00'
  FileUtils.mkdir_p "wallets"  unless File.exists?("wallets/")
  def self.discord
    output = ""
    self.generate_address.each do |btc|
      output += btc + "\n"
    end
  output
  end
  def self.generate_address
    # Bitcoin uses the secp256k1 curve
    curve = OpenSSL::PKey::EC.new('secp256k1')
    curve.generate_key
    private_key_hex = curve.private_key.to_s(16)
    public_key_hex  = curve.public_key.to_bn.to_s(16)
    publicKeyHash   = public_key_hash(@public_key_hex)
    address = generate_address_from_public_key_hash(public_key_hash(public_key_hex))
    return address, private_key_hex, publicKeyHash, public_key_hex
  end

  def self.generate_address_from_public_key_hash(pub_key_hash)
    pk = ADDRESS_VERSION + pub_key_hash
    encode_base58(pk + checksum(pk)) # Using pk here, not pub_key_hash
  end

  def self.int_to_base58(int_val, leading_zero_bytes=0)
    alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    base58_val, base = '', alpha.size
    while int_val > 0
      int_val, remainder = int_val.divmod(base)
      base58_val = alpha[remainder] + base58_val
    end
    base58_val
  end

  def self.encode_base58(hex)
    leading_zero_bytes = (hex.match(/^([0]+)/) ? $1 : '').size / 2
    ("1"*leading_zero_bytes) + int_to_base58( hex.to_i(16) )
  end

  def self.checksum(hex)
    sha256(sha256(hex))[0...8]
  end

  def self.rmd160(hex)
    Digest::RMD160.hexdigest([hex].pack("H*"))
  end

  def self.sha256(hex)
    Digest::SHA256.hexdigest([hex].pack("H*"))
  end

  def self.public_key_hash(hex)
    rmd160(sha256(hex))
  end
end
