Title: Python 2.x Encoding Notes

## ASCII

char to int:

    >>> ord('A')
    65

int to char:

    >>> chr(65)
    'A'


## Unicode

Unicode table for Chinese, Japanese and Korean:

    http://www.chi2ko.com/tool/CJK.htm

char to int:

    >>> ord(u'字')
    23383

int to char:

    >>> unichr(23383)
    u'\u5b57'
    >>> print unichr(23383)
    字

    >>> unichr(0x4e00)
    u'\u4e00'
    >>> print unichr(23383)
    一

c = u'严'


