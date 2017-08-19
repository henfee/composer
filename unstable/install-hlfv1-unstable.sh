ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� _��Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,/�Y.g�0l,�2O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�o��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c��Q6G�?�
�'@xpJ����ϙ�V����;�m�̿p����矍���8�s�o��HC�#��P��Z
��@i�?M��:���+�g�R����1�h���A���i���{�,�im����ǲ����?���:`#�_6̑SV�h;>��A� ��F�����(�!�a�ݬ�k���_g��l�h�I�Q�0��i��Lh�
I��c <����`�1 �M�� -�Bۮ>��}��i;�t-���	0-�/;�F�r!I�]�cXSN[S�ۤG"b�q^F�F�y�ۦ���t���v��f�����d����&�ѶUQ�"�����_�d醫j͐l)�Op鶫� ���	�=>��$a��.4��v�W���p"<�Γ�P�R���0?�"yYh����TΨ*&ޘ+�j���T�e�'jZ�|��	����|��1q6cP:��a���A��z��Z�N�����誚F��{F�D,W�U�}�Q��ƅl�0_��>R�!���E��0m��%���;lM�Ȃ�n�4��W�#E�����[F�ζC�=�3� ��讦a������L�T�87ٸl����2���e��z�TB-����x �਑�$6�m0����y(d�������ń{�n#X��*Ƞewړ�@߁1&�n8��̼U�H������ZYSd�ڐH`|}tn�$f0��sG;V��ޯ.��;rU�´7�s�t�@y8�a%�GjP�!��:���l�π������{@���C��ǜƍ�/)���TO�_��_���5"�����|Np����^qz@Âr���kĩ�ǈ�м�-@HCx�Bu�th�
�4t�Y��T���cFz0����?��7��:`����a��_����@�Y��O�?����<;)}�~�3ϳA\3��ӦM=l�Y�FS���Zr�3�\��5 ����R�\y�ꄪ��*g�T9wX���M�/���-���3�~�1�|��I"�r�Y�1YΥ��R��+_]\]�;�;� T�����n�=܀���/p��,���PP���u��V`��d"�Tf�T�r���+H�Z�f�'����
���d5�3]�(��
^�]h�����cB�����,D�w��;�|n�{�->| �-	1.o$u�).��5�E����^���,���	X�!���#���uz�-
=�E�������
�98p���#���l�q,������ˆ��?�rr�H�q������_<��S��j�=��Pu4!�B!ӂ-���qT�@e�h�{����������q&�n�?����p�p�|�H�����N�7�X~���h�����
�������+�]���=�e; Z�a�LK���h�'�M;L�x�o����� B�V:�C�쑺g�Jb�α��{ G!���A�<c!2��O7z_�Q����a�N�)2jZ��n��AYGY�/��:x��������d�������B��Y-���Q�1Zȯʎ�P�b�斻>q�f�y��{X�B�gf�?���X|��9F��~��#{��$ qN�vD{#=L\:x������؉���f�̨nj�B�cz��}����������?��.���Z<��?�"�]�1�n\����_��tA
��+�� ��a�������x�̏�'��q�y+���X�.ay���g�E���_`7������[�?�+"��@ �o` �U���z]d[���"	�";য়�Tʀ�W%������;�K\F'pz�<�լ�W�L^¡��u�	�5B��o|(����6n���p���y�q�T��n�;�Ҍᱬ:U�;1eƇ�T�ota0�E�uE�1�ז1��#۠��Ots�q7!#ߊt~A������e�X`��|L������F��|�d�|�͜{�|n�ƣ&��
�m������.�;�]0Q`έ^�hA*$�r�\O���3�'�d^J��c� P}���,��Đ���),є��p��(ѐ���T�,�JR�LL��R�"֪��T�RUBn�^@=I�r�Ɜ�HG���\ݗ������K�l��=�Ku)������Lù����Ãܙ����Q<)s���a�+��W�T����LL��R>�z�}WgS]��B�,Kս����U��٨"lMջ�	�`�1�R���Ah�5��t�	�s�x�����พyS�;/�S��*����-���i���6�������؍�Ǐ|$w
��v�J�P-�&�ȩ}@�`��6�st�A�t����06�^b�O�C��������bѻ�o/�+�[���䟽WВ����;�M���������R�E����?؍�_|����A��C�W�.
+}E�%$pD��e�:8�z���Ȗ�����7D��Q�;qK B�B �w��m�+��7�)`Y��K��lt��.����������'0{F�5,�kQE^]�z��E髵b�J�٘,s��_V��s)�"����r���[|���ņ �����;h��І�ˣ��	gp���e��>���?�7���?>�m����}��Q�X6��c�%�s��� �P�҃�7���KQ�9Gc`����<���A�������3s߂��=�n�3`h���5�Օ�WV���� V�
DHL>�2����gS�FQ���y#e*�"��H��w	�X���M���!�~��C�[�@�M����^�G�m���g㬰���V��k%橧�s���E��?m�	Bts��Z�����3��7_��o��?����������/0�`��;-�UX>!�-^�I$b�F�㹸y�1>�HDyE�B"�6�;��������߯�銷�[�F�I4MME�2D��n������m=��9E��6,Gu{[���/��h�N��߿ں�����W��R o��[���o�a���/_��?[����[OQ�?�p^�&y~�~���g�fX]����R���(����;���9�e�X�������F��>�{���?⭆�Di�m�qTf�#-���A���?h�u���`�
D��L�һi[mco\�l|�!BaY^���-F��D���N����$x.
���iʌ��B�ٝ��h�qYN�<�Ԅ:��#�@�j[x��	aHJ�\��r5�ɥĪDR��\.�=O�D%����ΕŢ[���W�f$�o�!u��A�}�;0Ns�猄pʥ�G5�ݬ�֤d����ҥXN��uTU5�-vY�׈�q�c�"s.ּ<����<5�}�+��{�i�'��E�*��0���MO/%��m��x��O+�y�c.�Ӣ���W��󽹘���R,T�A�<��9�T�q�8휤1�����y�Q8����t��(+��k�R���.�,q[>>�+=�<�Jǅ���B�^�2nN:�����y�Rj�����#"�P4��8J�B����F5y�F2Y�&��f+>!��l*��H�"��Yw��"y�f��j�n����[����\pbi4���侞���Z��:�ă�ܬ��P���O�Az�X���B�;�a�=88�V���ȣ�@�6�)�9�o����r!)�v$�\)���u�1��Y��O撉��U�w�_����\*YL*+��aq�[�q���D�-�Z*w��탣�{=%�mTO �#_&��D������s��ǵA=�O5#�\�"Č^�Ͱidɔ�ܠ�������za�Pf�a�O���b�,��	�K��1����p䗼����Xq��O������5���1�' �H�L�H�[��܆�(�7
w\�﫻C�E�O���i�������,+l��v�a9WG�8�NH�S����5Y�m�Nf���m���6���|��P#	�ۈ=�NKb���oa1{�i}-���e��H��2�R�X��)��V,��Z�2#��.�|/����������,���Z}�˪�T�X��[-q��1����|z���L:F!���|��ԣ������뿰Y���l�w���x�y��ܜ��ߜ�]��Z2�K��Lw N�}�GJ<�B�⑒>j��XR&]���7����Y��mʇ��S�(eN3���|�֭gʉ�a�F�d��KGwz�x8`�:�`��ޮ�����.�Ӕ}�Q����h:,i���P^��������h|��xR�9�H�d.Y@���05�q�ʐ�E3L=ñ��鷡���r���Th��C�a�!�����.yH%�m� Ұ��*��2Z8�K��K␶AO��6��ƏZ"g��&)@>=��������(�=�h��ѓU}�H�C��k�+&T�,V ��EЀ�1 !HX�hЁ ���#QCH�H����dp|�yxF�wi._[��,<�����>*��9w:<������8���:����%a���ws�h�A"d!���Y��p-�>o�v-�Wa 
�����]M�+G^O�Q:!����a��6y/�7v�ۣ}R��m�=n��csU�����w�m{��p�]��E�� !��@H���		�
���
r���@U����Ǜy��G�gW��_U���GU���D�y�x�����HQ���򹣍�n6�1F$�L��a������7}�*m��65T%Hj�	]�.����Ƒ��r>����	)�����Q��s�#ӽ�u�A�O��9c�q��?�uA��f��C�4`�3�d|���p��=+��1�=��s�w�uƇk�����x��� �rF���{W2q�&���X>���S�����ʠ6����K8Ar����(����/�mh��f���iC�S��S.��:M	�8���u"H	��5�����2���e|�� ��*I`rI��������g_`hgث����B�14&�kJ�� za��1rY_����\��0�6P����='W��1YO)oص�)t~��^�Z:7�bOH>ƙ�|�l Gr���G�2'�#B����f��?E�KE�ɚL�����c�����`ـ���F�%�1�H0�R��Ԛ"�@��է&�"h+�v`+�dX}��kҝ��Q�@U'��x;��vYR�p�ТC�"�2�rm��+�5t]3�{9⚍#�n;tnlt����L�	+��֭�/sz�~�Q7=)�ar��4�����ߕ��6B�o%A�����)��@�������16�T#�܍�f}{������6$������S�X$�1�OF���z%bo�����o%~����/����:'������_��'6���'���R�oS�oRĂ�՝��}�����X�юl|&�&�E<�Kd䨤�{qYIĒ�x<.�b�^&���{1�J� ��{;��g�$̐PzJ\NK��n�ß������d���=����o��?����Wf�"��#�_�������������t�����=\ဿ�p�?�@_�z���z�z��oa5ڎ#`�� c����آT���}K/f
J�<k�K1�z��U��K�1K�"n����UD `�����/Զ����k.��(7%��JΎ��K:*����Y-!�u L[8i5?�
�<����-���(��s��s��m����0���z_�����8�a�j}T�K��-τ���٘���3���yixo�([�7��h�궝W1Kp��Y���Nx��jbP�v�Ͱ�����G�3�K��p)lr��e����yD-�r�o�c����U��V��?���2�+�Թ=S��f&���r�EլG�t�fh��j~(�i+B�t;O09�Y�qӦ�lI�1��x��恥��LN-D-n*���|Ht�	�oē�b,J�Ѡ���7a�l��Ӽ�]L��z��bڀS��g�zb�����ɾ:�gM�˶�G�����'z��H�Y�Ѵ�t~��gc))V��`rď�#j=!}l6«������j�]���]ї�]���]���]���]���]���]q��]a��]Q��]A��6�����K��(���[�o"Y���`�����7;�z�9[R�r������ۉ������-9?_�����(Q(�o�z�{n�z�v@ ���;�p;�Cx���[V��Q��O��9-�w�r��R����-�Y�72�Bt KrԌ
'EZ;'"Z�O�sM��m]�TO&T���%j������q?��A���t&D�ɕg˓J���
�ϖ6�M�|Ҏ�k����Df�L�"�\.�T�a<�&��4Y;7j�Ԍ�HĬb�J�<}RJ�3V/Q��W���d�ӬL�UB��X��z��,�rWhٮ�7k/�ڿ���/��z�	��}c�ݷ�n.7���v��0G��[v��Ʊ/��Yg#\�����j�Zw�4���7B;��Ga�.쾲	��.{��-�N���˛�7B���,[�G�PmqR�7�~�M"�+����#7|����y���9J��kMYi	M�V>��ҳ�hjL�i-�\�~��{�>�/���X����ltS�v�1,,g'��c�E�&j���,q��9h��t�lNuM�mmZ��iz���o0B!P��i�Q��������F��ZL����r��4�M��qUɝՈL�o͎�̐*W�^j��a��ю��$�JJ��mkމ�f��Z�sEU���c�J�ĉHW+��>�e��,���f�6���,]��H#cZY<dV�iL��jV5����g��S)�sh����k�ͷK��Xs�j�@�Gk�v�,Փ�D���pxLED�$�T`�FR�fM�K� D��>��5�G���H��ue�3�Z�Y1���O|�?�*���k�&�e��k�b��Ú0-��t�b��~}y���_��o
����f��[��^���}�?�V1�V�b�^�ϸE�,ʺ�x'�����3��;q[}�ԝ�1��v���@j��Z�f.�N!����L�L���Z3��R5�Λ�|�ak�QC)�����Vk���27`�S/)VǮ;
N��k|����� �)��F��\8s�Wh���@�s�@����,gL�f����s!a��j�Ws��L�{��T�~�tBW%�L�?V���p�U7 �z����uO�U%�9V���@l�c��H͊����w�0��E�0*+���B�7�4�Kѽ�ha[\#ӧ����Z�H��g/�յ:Q�#Y��P�k�щ��
T�)�}.D%�ľZGb�y�u$�?��m�`����	q�%ϙ�8�Jg�t�s&u�{��y�w(��(Vkw���}3�7�QM�!��p��`�eM�׊�g�Z�W��r_S@�3�v9�`�UN�ͦq����ez:ӈ��?A���<���j���yl�����6P��9�kjq.��gJt�e'� ą��ay}��D�%��f(5^LԤ��J��-�#�''�y����M(��؇3LFk�c7���%[`�s���t�0�b��meV�pW)���V����G0�ĥ��	�n�L^�{�LQ?ؼq?��x�V�/:g���I�5=��_&��j]1���8���B�Z�UF��c%�~�-�M���d��y\FC[*����w�����K��/�$�6쭤�h㠇 �'�GEh<Y|�yЄO���^�]��+.������0��H�uՀD�!
�	�d�m}J�"����-�t�E��?��O�ﻝC��D1M�%B�ć.�)�6�u�\�I�=�Ke�x����ϭ?�x���D��f�_����_$�p�C<���߫������_��Oz7M�������)���5��wʝ�A�B*��|��Cb�&�.:LƬ�I��*��vUA<CGž�vywg�l�ؼ�}um���J@��|���}�:�
s��D���%�?[-��O�Y׳\|�z��5%���@N���_�T�pK�>Y� �-�	<��x`E�kP7H��z=�1.����B��?�:�����ba�078�'
�ԅڀ=�]v*zC}C�.��60"a�HNM�2Z���NH��H�oLu�)�g�F!`��O��/OyIS˳��|�V��*�0	 �L�>�O���Ǥ;~��E5v�+s�i�DW��6�!l,|�x��zg�n�18p��g��*�Ƴ�t��0W$� ��F=��, Q���jۊM�s]�X}�i��ۦ_����9�ɵMCaï�j0��fxh����+B'��
LaL��ы�Ir+#���Du�1�ɺ9:�L�NU���݉�˭;�c ��Xٔ�&���wo޼��1Ѩ�7&h�����8�h��y�6��?h �:��7�L��g=���6��VOG����!:]l*FO��5F.�u���wo$�y���[h���Z�� �q+"���j $%:���<��Jy��Z_����F|>6��O��xd'�1����-��%k��ٺ
����8��o�}��:
7�D+�ӫ B�+HK�����=�h���t��{h�acz��7 ��-�)�8e����u��ͺ���e�]+q��前LF������3<�6r���P^�'��rHF�u�h��Y#kb���z��o��ܰf�!�;x��X�(`N
N� fv��p:�V d;V&C����70w�y �H�4Z�r�Bߎ�e�#+/�b��B'�����@d땉t�,yU�U�V&�-���I��]G_hc�F�����^?���a�7A�z[�q:f�+5����p�B�	�[c�Vm'�J~cWIPQ�ȕ�ғ�@��� � +�k&ט���x�c`��=��0*WD��I�z�n�F@����+k�LS��M�:�D2ѕ�n�sC#��ڿ�TY�h���ҐODPpc��&����#Ų������K7�n ��^�+ ��j�Ap�H~�mFx_�l�;�U�������;q�-����T4���-u��}��+���
�i�S�@C@�:Qɖ;7[�/Z;��]i�:0�Ym���L�Ϟf�St5Ƴ�bu�[���rK�W?���[��,�Ԗ���\��Y�/ݠ�մu��St���X���#��b�hT�X")E��LT��K���^���(9գ �J1�&*K=��I�x<��h��ǒ!��ݾ��Xq�Y�i�e>0,�O�䧛�qB^�)L9@Mŗ�ܸ[:���s�,^�%�R2$I��ӑ�d*�Ļ� $�񌒊��i%$�!bP��O)H
�|*9 �c�|*��1���P	�� ��.޴5n����:嶍bH�mb�5��kTv�탗�m��ru8��\��ӥ�R%_⎹�3Y����d|C��4�ֹF�Y�W�K�ѿ�!pb��>Ë�אn�/o���-kW4*K��F�g�Ȯ�Fw]]���{�]xe�@��Ne�>6�VX5��Z؜têf��L;k]k�#*�h:�4:3�-#��ǩ'�5�\��.�
o�H Kݔ,}����r��c�����l�ΡQ�����*��7F:~�-�|9[aW��R��̯��\��V���l:���pm���$<������P�~
��HAZO�.'^]ڬ[����JC�V�9>Z��V�~$��=���4�ow��5�q�$/�T�{��U�זU'pl�m���9YZ���=ˢ�PY�
�l��-���ޕ5��5�w���N݃��V}U�&@�B�A/�4!�I���3;v���z8�C�	��ګ{w�V����=]��a��$���	�b��e'���W��6���?O�<����t9v�;�����M���S��_��]ӳ��7��G��:��s�V&�y��G����x��~=��m��g��ą��������~�7w���Y����.��G���i�?����_*/�K����?�������^7��b�M
�?���H����\����g�r����$i���G�߾�7���gh���G,��9�����o���?������� @��o���G�����������@������D����i���r�Kq4s�����`?�3`?�[�g�~�	X�?���/�H�J�ő䟣�QL��H#��,EF����8�CI�0�ER1!�	L �b�QL����~�����C���ԭ���_H���{>&����`��&���-�j���6��e���w-�=L��������q�l�7����B��[�LL7��GX�c���ɔ���1�ixgjc�ԇ�m��l���cH)���R��s�ǳ?��������������PR�����K�� ��8�?M���3��(���PX���� ��/��o��  ��@��)�.�|j �����p��������RY"� ��/��9���y�����>���*Qt@��?��di���)��A��	s:aN�]��.`���;��P���Ї�0@�������� �#F��� ����n�?)
�x)��/������Ճ�X�R6�K��K�n����
��Me���ٽ�~�����F�5�ͽ���O�m��y^}˪��m}�Om��̦)~�h�l���S�~TQs3.7˩�qY���i�:e��p��<�Ǚ\i��~�V���T�X{������q�����r��S�'�+}�U?�o�TOjt�����,������mc�:6���h�ް?��T��iy�N3e�뉙I�s�Ҥ���R�f�4
����%�Q�C���}�q��\]��~���!�m�:��=2�^���������� 
)�b ����X�?����\�P������ ����	�����������A�� �/�$P�_ ������7�������o����C���������9���������L�t�a�'m�]u����J������ǰ>������8�'^:�o�k�Z(�À>�<�:��L6Afo:�!h���]���y�[K�Bh�r�i(F�S�I�����Glk�l�5:�e��,SO�a=�}\˦�_�z��'@5e9o<��SE�sc%w�O<����9�m��;�k'�h0���O�3�^��*^�3s(l�Q�r� ��#O�V�����(�YE��S=�W2rb�F��=NZ�������������G��C��,>��jC�_  �����g��W�/8�G��?��8*
I��8�X�#9I
b2f1�PC�g|^i&I&�C�����I���������C�����?=5���0QV�r�l�D�J���$�Y*1��6���MT�G�[#g�g;�}��w=Γ�{T�;J]W���mg�C�އ��x�d� �
Z�&�D��f�l�U��	�T�ݲs0������?�����l��������C�Oa���>��sX�������!�+�3��Y���5��~�O��!v^g��k�wgͭ.��79'NW���Oo2|K�I�<|��uimի>s*��Q�LBU=x,9K�N�2�~��=�t��Jm�+u��"��4l�m]&l�x���?�߂������ۿ���	�������A��A��@���X���p��Β������Y�%�W��v�fUU���b 4�O�����?�����'��ʲ�g�5~� ���;f ��ٻ3 �R5����T��T���g ��~�b;nC.��يi�VKzFμ�h�*e�Qύfe9u�SUO!]J�N�)4��Ϊ���U��՛��JV�\L/̉ĳ��~��.>��^f �nE�M�l�D�(g�I��WhѾ\+'I;�����"uʶ�X9-��Ek�b�Vj�n#5����ǦRR+Ke����R�*��p;i �M�V�� �ݺR�]�*��QS&��H3�Kbŏ6��N���<Q��T��U�{T^�g��Yc����yrP,��?κ��f$��h�����;�������>Tx�����y[���<�� �O�w���	��?x�aT������@B������������?Q��_��?J���  Y�"?��I_�}��Y)H�c���4���H�bV�)��ch��0��ߩ��8�A��Y�뵂��d�]n�{]��&����A�rvlmz쉷Lves�c���т�:��G�9�Ss�4�����})����֓E��HZۭE���I�e犧��ήf�.-5�[Ub�Jw�"�E�_���3��?H����x(�[~����?OӐ�G,�����C�"��?ZL��G ����4}����?D@�������q0&@�����N��C���/翡����ڵ�=�t��J����>��7��ᩐ�oM���u�����F����r�M���;��v���}N�R�xċ��՝�8(6U����[5��5��)��ژ�w�u��l��=a�qGC�!7*~�L&�)x���5�r#5�v��X�XM�ƴ�U���V��Y����~Y�Z����[Yl='(�"�Ns�7��C�o���Z��	]�j���n����]հU6m�<���&�cV�Oח��W4���e��{�^�ʉ�8\�_-��1ZUV��׍ܔ��Czf�퓓��J�>�܎�uY62���j��4���
��?��Á�����-�C!8n�!��S������P���P���p�����_6O!�% ��������“��?B `�����9��Q ����������;��$�?����^~i��p(��-�?�?���4I����?
����e��-����������!
�?���O��� ���?�C�������3��?� /�s�@�����������?���]��.`�����/� �:C
���[�a���M��?"`���R p����?0����� ��� �p��� ����ϭ���8�/x�?�C������ �������������G$�@���������[�a�������ߑ +�����!����� ��P���t�.`���;�����Y|L��6�� @������<�`�:���u�|0"CAdHq$J�(d1�X������'�3O�>%
�P��K>�r¿�G��/p��� �/�����;G@��ЇO��v�8�E�J���Kn���4�fSi�&ei2x�k�=ҡ�U����yE��S�a/�ݸ#[�,w�{5�]��6�٩�B��c�|U
�`{3�hw�#W�ǜ۫��I���Kw��u[tL��\��ݱ�պd��s�2կ��͗*��c���,���N}�?�������?|�?�0���	��C�W~g���;��V7����5����X�M�ѩS=��
�>dGy�/�����2g�̭S�m���v;6��|�٣��$���7��@*Ʀ�wJ��TO���P�7퍩�[�.�9�4���YN�c�� �{-���o�C�0��C��p�7^�?8�A�Wq��/����/�����b�?�� ����������x���ZW������W=F��[~��t���>������n����.�NS<ūR�`v_���c�Mw;[w�rI�Ϥ�:��:H���l���Fa�i�j3��d'e����4��T>�2i3bR�:N�	�fOl����Ԭ�r�V����+}���.�z���݊����^�*�^Q��:y*�ċ�-ڗk�$i�Vu�S�@�Nٶ+�Eb�"aZ��J-�m����l�jԄC�n$�i*f"FF��=bqh����I�js�5�btC-���2�(�ͳR$��*Y�\)�m�Yy�\s������+�N�_m�x�|x��<��I���+���H���|��+�������G�?����	��H������J�����u�gI��G��&���_������'xz�T��S��y����<��P����UU9:~��0���^/agR�Ҍ�>cޜ�����?*��<������U^}ȸi�_�tV:'�:�ì�ה�ֹO)?�k�������7Ϟ�.}SI�R��K�򒹼���ږ��rWI��L��|ͺ���_
�����^�Pץ��;m�hs�y�K[�J�ֺ�ʣ>-�=�1Z?��kʟ˒3�ʜ�5)����7�2��O�4ޮ(1t����xM�]�o���8w~^�\I���gY��Oi?�����%�V6��=i�=QTEp���))�fy������N��r��JӘ>�ږ���Y�>�2'VM�]�(��9qD�J�:g��E���u��@:����`�4S+���2q˾�;�!��An*�!�O���5v~�z^ؗ��6o�o��	X�?������x��a$R,�K#&����,J#��I��B�e���r!��dHE���Q�!����?�?��C��Y����H�y��hO�y@�m����񧻸~�6g�"z�)�c���\�V�o�+�����G?������K���%0���H������@��/�����?����k�.�?�k����}��N���?Z����(����]���0�<��9w��]l��r�/�~�{r������Tܧ�_�)����#^����I��l�DUj���w�͊b[�;�®W��u��2Ƞ]���ёȤ�(jE����5�fjUfe�*�+"#��GYg�s�^gO�R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$�C�u��:���S5��:�Z;6�2?)3L�J�+[�S}.������3�D�����8�{3I�G��u'862f��u���(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c��q�+����{�?P��	2��)��Iݠ�U��U�Hg�t:yE1�aj��jU�b�=��*N*�S��Z����"���Ϗ�U���@��=����ؠ]_�H��co�k���4�GrX=���?Ҽ�p^��~_����V��_��~�S��o�c���@�_��n��/d���i�/��XH ��������2���LY����`7�?�C��	�4�ç�ڇ��s���o�[-�������?����a����C��u�3;���Xw;��D�0Ađ��H����Sg%�:�����&��˶��m�d%��3WȷN]]g���+W������X\k�;/}������TΫe:S�,u�k������ɢ�����i�����}cz�u�-#Z�wQ�)Z����U~�F��w�N[�Xxl��/�?
���6���˼ϊ����e��{lS[��#eKl��ܗ���kZ���-���;yb�Ҿ��&'�e�m���>��i11��t=/}A2�*���n���`�:�U�U�!�k���Ú�w�#aX���1��Զ��d����"�?���ߐ��	���u�������E�X�)?d���Z<"����d�����	����	��0������p($ �l�W������1��\�P�����-���� ����������A��E�Y�+������|�Ob�g�B�?s����!��I���  ��ϟ������o&ȋ��q��� ���?��M���������������?yg��?���"'d����!��� ������؝�_���y�?(
��?��+�Wn� �##���"$?"���H��2�?���?�������Z��/D������_!���sCA�|!rB!������a�?���?���?�;����2A��/t,H���?��+��w� �+��!�?/"����� ��������B�?��������[�0��������E��
~���������Ve����H����Y#R7եY�R��T\'i�4����H�aL��h�}�V?�E��
}�C�6x���$	�JMa~���k	l�kK�i'�d-�[���ױ��$,Vӱ�~ߢ�k��~�k�?G�C�T�oLM���'Vt��m���t����A����L��ݸ�K=vI|�F:��TH��U�JkO�=K"�8i�Uf���Y�ʛ'����X�W�����M���C����y���f}��"����"�?���<���OI�w+<.�������q��&��8�St�aH�4�qM7�iܱ�ͼ�3�H\�����5�ɺ��tGkWӃ� ۉ���F.��{$!�pr�T��a�g:�����x���H�N��^�V��S��Z
,�Ň�<�!��Z�����oNȳ���'=��o�B�A�Wn��/����/�����9������}��*8�,�E��g������+
D?����,OI������?q�����K�s"��p_[s��@n��`�z���d�ko�>�aTw��N{�1�NUm��jެ�T9�8-��xZ�1!f.�sy��I�fn���b�ިK����}�6�A��+����,yQg�t����m�]>k��X�|MV�Y�����s�B<����~�u�Y�.Er��� ���-(uֱ�R�|�+�''�Od���������.�f�P�n-������l�:r��	<"��S9�M��;�vuL��	�I�#M�]]��n㨲����^�����)/�u��r ${Y|�_���n�?*L��	�o�B�?s��������ˋ��'��������n�?�P��Y W�O���n��?����ߩ���L�;��Z<�xD ����������E�p��Y����L�����, ��������B�?���/�L���� s�����
����Cn(��򏹠�?}[��A�G&�b��9��P?��Q����㦧��f���o�?�Q��z,�_�?b��#-�@���w�\��~�Wj?���+jgmn|���^�~�������+N4l��3.6�=��J���q�Gjt���˚�w�.&k�F�q���i�:��f�/��qA�a՜�g��X��+����ֺ�k�/r��WՄ��p,j9�ؔ����0�*mw�lO��8��SV���l�_��:3���$�cם��Ș1�z�����Q���8֑frֶ���Xد�8js�a���8x���RHT�ۛ!�d�^?΀A!������߫E��n�G�����
��0������/a S"�������& �/���/���7�'a�''��>.�wS<$ �l�W��0���P ��s �5
�C�n�R�_��������t�l�;r<�:Q:֨=�P��������X������6�;9]��� y��C@������=��v�*�U����,~wؖ�y�pWS!���a[��'m�veb��.:�������XkB�~ ��� $-���A��V���Mٮ	>��e�P�VKېhOA�;fe[k�s�jZ��9*��i8V��;{P��JG�8$��˚9���X��>��fB��w���L�����x�-�����_������ �g���?Y#]�0�I��Z��Ʋ�i�IaMj8E��Uk��&�2�iR��1�Q�2Ē�߇o����Q����'��g����Y0C���Zk��32�����j2��Š��kјG��u��S���h�`�u?P� �:���z�A�5%ǶoUT�s8,�\u���<�)�s���r�@�L0̀�� ���V�h�~-�����g~ȵ�O�ʻE��!�����������"�I�wS<$����������fj�D�')�Đ:�&���x�N+;D��\�D��5�����ڍG;���:�l�=r��1�jN)ďNCaBͰʄ��]�:�y_i�bD]I�I��ho���oBsv�H⿯E1����/*����=r��u �������� �_P��_P��?��������(��/'|I�MS�g��_��}z�z&J���4�0�&��o��^j ����� ������
��F�����˼��eŌ���٫���EcR���|�!k���U&:��p�l��Uʵ�y��VS�CEk��E���r�ϭϟ�<$�y��ƍ�����Un�s��l��	���\��?�@�8O$׏Z�_�J^4֔� �zĺ��3���}��bD��y���Ul�Q�Y/f�Fw�O��\n|ط���ό9�8MX�ہ�0:����D:{���b̞6���1G�6����BH��G�P�E-�>�ӃМ��5����^�װ��`���oo�h����):~]�����D�}��IW(��,p��-�+%��@��һ�����O;����&�z��ATYn ��yQz�cG�_~�M���蘞�lMgc���_N�"��cB',���#q���.=}�}��.���t����U�36�S�\������I����[������-�|@�_���OI$>�y
�?�_���)��矠��x����Ts<TSCA�Q�NT�z%�	¨d�6�w�/*��M�ĸ����ЈJ�C�)P�Rd%}Fr��	=�'�.~�����e)�/�ᩮ����c�����x�����o?����?�Y��e�*9+���_���Ӈ�A�	)���eC�y{��1O'wSZnc�[߻�K��}�j�6�6(5N�l��e��#Q����'$9��t59�ּ4_X�턼���9�U�$|h���0��OIu8b��#�-tǣ_�{��'y{W3��A�ޖ~��ޱ�!��0��ݛ\݅$/_��]�9�C/��`O���_�ϛ�Ǘ��)�mKwb��b0
KH�srM�5"�?6ze�{D�^��u�߻���_���'w�.���݁�'���a��vDYz�n."-B؇)�]�����~���Y���N���_�����>==d?   �b���[]� � 