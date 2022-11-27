import 'package:flutter/foundation.dart';
import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/platform_check/platform_check.dart';

class RSAService {
  Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> generateRSAKeyPair({
    int bitLength = 2048,
  }) async {
    return await compute(_generateRSAkeyPair, bitLength);
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRSAkeyPair([
    int bitLength = 2048,
  ]) {
    // Create RSA Key Generator
    final keyGen = KeyGenerator('RSA');

    // Initialize Key Generator
    keyGen.init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        _getSecureRandom(),
      ),
    );

    // Generate Key pair
    final pair = keyGen.generateKeyPair();

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  SecureRandom _getSecureRandom() {
    final result = SecureRandom("Fortuna")
      ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)),
      );
    return result;
  }
}
