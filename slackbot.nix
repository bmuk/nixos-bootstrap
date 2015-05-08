{ stdenv, fetchGithub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "slackbot-0.0.1";

  src = fetchGithub {
    owner = "bmuk";
    repo = "slackbot";
    rev = $COMMIT;
    sha256 = youguessedit;
  };

  propagatedBuildInputs = [ pkgs.nixops ];

  meta = {
    homepage = https://github.com/bmuk/slackbot;
    description = "A slack bot which interacts with nixops";
    license = stdenv.lib.licenses.gpl;
  };
}