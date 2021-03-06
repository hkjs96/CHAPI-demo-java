package kr.co.futuresense.demoweb;

import java.math.BigInteger;
import java.security.PrivateKey;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;

import org.jose4j.jws.AlgorithmIdentifiers;
import org.jose4j.jws.JsonWebSignature;
import org.jose4j.keys.BigEndianBigInteger;
import org.jose4j.keys.RsaKeyUtil;
import org.jose4j.lang.ByteUtil;
import org.jose4j.lang.JoseException;

public class JWS {

	public static RSAPrivateKey PRIVATE_KEY = null;
	public static RSAPublicKey PUBLIC_KEY = null;

	public static int[] N_UNSIGNED_BYTES = { 161, 248, 22, 10, 226, 227, 201, 180, 101, 206, 141, 45, 101, 98, 99, 54,
			43, 146, 125, 190, 41, 225, 240, 36, 119, 252, 22, 37, 204, 144, 161, 54, 227, 139, 217, 52, 151, 197, 182,
			234, 99, 221, 119, 17, 230, 124, 116, 41, 249, 86, 176, 251, 138, 143, 8, 154, 220, 75, 105, 137, 60, 193,
			51, 63, 83, 237, 208, 25, 184, 119, 132, 37, 47, 236, 145, 79, 228, 133, 119, 105, 89, 75, 234, 66, 128,
			211, 44, 15, 85, 191, 98, 148, 79, 19, 3, 150, 188, 110, 155, 223, 110, 189, 210, 189, 163, 103, 142, 236,
			160, 198, 104, 247, 1, 179, 141, 191, 251, 56, 200, 52, 44, 226, 254, 109, 39, 250, 222, 74, 90, 72, 116,
			151, 157, 212, 185, 207, 154, 222, 196, 199, 91, 5, 133, 44, 44, 15, 94, 248, 165, 193, 117, 3, 146, 249,
			68, 232, 237, 100, 193, 16, 198, 182, 71, 96, 154, 164, 120, 58, 235, 156, 108, 154, 215, 85, 49, 48, 80,
			99, 139, 131, 102, 92, 111, 111, 122, 130, 163, 150, 112, 42, 31, 100, 27, 130, 211, 235, 242, 57, 34, 25,
			73, 31, 182, 134, 135, 44, 87, 22, 245, 10, 248, 53, 141, 154, 139, 157, 23, 195, 64, 114, 143, 127, 135,
			216, 154, 24, 216, 252, 171, 103, 173, 132, 89, 12, 46, 207, 117, 147, 57, 54, 60, 7, 3, 77, 111, 96, 111,
			158, 33, 224, 84, 86, 202, 229, 233, 161 };
	public static byte[] N_SINGED_BYTES = ByteUtil.convertUnsignedToSignedTwosComp(N_UNSIGNED_BYTES);
	public static BigInteger N = BigEndianBigInteger.fromBytes(N_SINGED_BYTES);
	
	public static byte[] E_SINGED_BYTES = {1, 0, 1};
    public static BigInteger E = BigEndianBigInteger.fromBytes(E_SINGED_BYTES);

	public static int[] D_UNSIGNED_BYTES = { 18, 174, 113, 164, 105, 205, 10, 43, 195, 126, 82, 108, 69, 0, 87, 31, 29,
			97, 117, 29, 100, 233, 73, 112, 123, 98, 89, 15, 157, 11, 165, 124, 150, 60, 64, 30, 63, 207, 47, 44, 211,
			189, 236, 136, 229, 3, 191, 198, 67, 155, 11, 40, 200, 47, 125, 55, 151, 103, 31, 82, 19, 238, 216, 193, 90,
			37, 216, 213, 206, 160, 2, 94, 227, 171, 46, 139, 127, 121, 33, 111, 198, 59, 234, 86, 39, 83, 180, 6, 68,
			198, 161, 81, 39, 217, 178, 149, 69, 64, 160, 187, 225, 163, 5, 86, 152, 45, 78, 159, 222, 95, 100, 37, 241,
			77, 75, 113, 52, 65, 181, 93, 199, 59, 155, 74, 237, 204, 146, 172, 227, 146, 126, 55, 245, 125, 12, 253,
			94, 117, 129, 250, 81, 44, 143, 73, 97, 169, 235, 11, 128, 248, 168, 7, 70, 114, 138, 85, 255, 70, 71, 31,
			52, 37, 6, 59, 157, 83, 100, 47, 94, 222, 30, 132, 214, 19, 8, 26, 250, 92, 34, 208, 81, 40, 91, 214, 59,
			148, 59, 86, 93, 137, 138, 5, 104, 84, 19, 229, 60, 60, 108, 101, 37, 255, 31, 227, 78, 61, 220, 112, 240,
			213, 100, 80, 253, 164, 139, 161, 46, 16, 78, 157, 235, 159, 184, 24, 129, 225, 196, 189, 242, 93, 146, 71,
			244, 80, 200, 101, 146, 121, 104, 231, 115, 52, 244, 65, 79, 117, 167, 80, 225, 57, 84, 110, 58, 138, 115,
			157 };
	public static byte[] D_SIGNED_BYTES = ByteUtil.convertUnsignedToSignedTwosComp(D_UNSIGNED_BYTES);
	public static BigInteger D = BigEndianBigInteger.fromBytes(D_SIGNED_BYTES);

	public static String create(String str)  {
		String examplePayload = str;

		JsonWebSignature jws = new JsonWebSignature();

		jws.setPayload(examplePayload);

		jws.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);

		try {
			RsaKeyUtil rsaKeyUtil = new RsaKeyUtil();
			PRIVATE_KEY = rsaKeyUtil.privateKey(N, D);
			PUBLIC_KEY = rsaKeyUtil.publicKey(N, E);
		} catch (JoseException e) {
			throw new IllegalStateException(e.getMessage(),e);
		}

		PrivateKey privateKey = PRIVATE_KEY;
		jws.setKey(privateKey);
		
		String jwsCompactSertialization = null;
		try {
			jwsCompactSertialization = jws.getCompactSerialization();
		} catch (JoseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return jwsCompactSertialization;
	}
}
