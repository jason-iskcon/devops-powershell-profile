import unittest
class DeliberateFailure(unittest.TestCase):
    def test_fails_on_purpose(self):
        self.fail("deliberate failure to show that the Bash/zsh step fails")
