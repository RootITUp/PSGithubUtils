using  Org.BouncyCastle.OpenSsl;

public class BasicPasswordFinder : IPasswordFinder
{
    private readonly string _password;

    public BasicPasswordFinder(string password){
        this._password = password;
    }

    public char[] GetPassword() {
        return this._password.ToCharArray();
    }
}