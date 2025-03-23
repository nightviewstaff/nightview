# Keep the CredentialManager class and its methods
-if class androidx.credentials.CredentialManager
-keep class androidx.credentials.playservices.** {
    *;
}

# Keep any other required dependencies or classes used by Play Services or other libraries.
