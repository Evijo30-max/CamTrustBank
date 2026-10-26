"""Controle SHA-256 du dossier livre, sans dependance externe ni envoi reseau."""
from pathlib import Path
import hashlib,sys
root=Path(__file__).resolve().parents[1]
errors=[];count=0
for row in (root/'SHA256SUMS.txt').read_text(encoding='utf-8-sig').splitlines():
 expected,rel=row.split('  ',1);p=root/rel
 if not p.is_file():errors.append(rel+' : absent');continue
 digest=hashlib.sha256(p.read_bytes()).hexdigest();count+=1
 if digest!=expected:errors.append(rel+' : modifie depuis la remise')
for e in errors:print('ECHEC '+e)
print(str(count)+' fichiers controles ; '+str(len(errors))+' anomalie(s).')
sys.exit(bool(errors))
