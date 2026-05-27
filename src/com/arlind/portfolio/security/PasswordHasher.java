package com.arlind.portfolio.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordHasher {
    private static final String PBKDF2_PREFIX = "pbkdf2$";
    private static final String SHA256_PREFIX = "sha256$";
    private static final int ITERATIONS = 120_000;
    private static final int KEY_LENGTH_BITS = 256;
    private static final int SALT_BYTES = 16;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private PasswordHasher() {
    }

    public static String hash(String password) {
        byte[] salt = new byte[SALT_BYTES];
        SECURE_RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(password, salt, ITERATIONS, KEY_LENGTH_BITS);
        return PBKDF2_PREFIX
                + ITERATIONS
                + "$"
                + Base64.getEncoder().encodeToString(salt)
                + "$"
                + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean matches(String storedPassword, String candidatePassword) {
        if (storedPassword == null) {
            return false;
        }
        if (storedPassword.startsWith(PBKDF2_PREFIX)) {
            return matchesPbkdf2(storedPassword, candidatePassword);
        }
        if (storedPassword.startsWith(SHA256_PREFIX)) {
            return constantTimeEquals(storedPassword, legacySha256(candidatePassword));
        }
        return constantTimeEquals(storedPassword, candidatePassword);
    }

    private static boolean matchesPbkdf2(String storedPassword, String candidatePassword) {
        String[] parts = storedPassword.split("\\$", 4);
        if (parts.length != 4) {
            return false;
        }

        int iterations = Integer.parseInt(parts[1]);
        byte[] salt = Base64.getDecoder().decode(parts[2]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[3]);
        byte[] candidateHash = pbkdf2(candidatePassword, salt, iterations, expectedHash.length * 8);
        return MessageDigest.isEqual(expectedHash, candidateHash);
    }

    private static byte[] pbkdf2(String password, byte[] salt, int iterations, int keyLengthBits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLengthBits);
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            return factory.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("PBKDF2 password hashing is not available.", e);
        }
    }

    private static String legacySha256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            return SHA256_PREFIX + toHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 is not available.", e);
        }
    }

    private static boolean constantTimeEquals(String first, String second) {
        return MessageDigest.isEqual(
                first.getBytes(StandardCharsets.UTF_8),
                second.getBytes(StandardCharsets.UTF_8)
        );
    }

    private static String toHex(byte[] bytes) {
        StringBuilder hex = new StringBuilder();
        for (byte b : bytes) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }
}
