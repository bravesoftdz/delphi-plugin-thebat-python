%Py("
print tb.seti('cursorbody',123)
print tb.geti('cursorbody')*2
print tb.seti('xyz',111)
print tb.geti('xyz')*2
print tb.geti('cursorbody')*2
")

%Exec("uptime")

%Py("
tb.set('from','foonus@kaishaku.org')
print tb.get('from')
print tb.get('215')
")

%Py("
tb.set('215','set@kaishaku.org')
")

%Py("
print 'm:'+tb.macro('%%FROM')
print 'v:'+tb.value('FROM')
print 'g:'+tb.get('215')
print 'g:'+tb.get('from')
")

%Py("phi = 1.618")
%Py("print phi")
%Pyx("phi")
%Pyx("5**5")

%Py("
for x in range(10):
  print str(x)
")

%Py("
for i in range(tb.paramcount()):
  print '%%d=%%s' %% (i,tb.param(i))

",123,456)

%Py(
"
import os, sys
os.environ['TMDAHOST'] = 'saakal.pair.com'
os.environ['TMDANAME'] = 'mlkesl'
os.environ['TMDAUSER'] = 'mlkesl'

from TMDA.Address import DatedAddress

tb.set('replyto',str(DatedAddress().create('test@kaishaku.org','5d')))
"
)