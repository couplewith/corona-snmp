#!/bin/sh


CopyRights="
##=======================================================================================
##
##     ----------------------------------
##      SPACE Script for Linux   V2.1
##     ----------------------------------
#
## Copy-Right
## ---------------
#  Copyright couplwith@yahoo.co.kr  Dr.choi in Seoul Korea.
#  since 2000 hanil life insurance - simmani - enkai - haansoft
#
## Update Note
## ---------------
#   add subdir summery
#            in 2002. 1.  1   : <couplewith@yahoo.co.kr>
#   add sort by summery of size of subdirectory
#            in 2003. 1.  1   : <couplewith@yahoo.co.kr>
#   add installer script v1.0
#            in 2004. 11. 12  : <couplewith@yahoo.co.kr>
#
##=======================================================================================
"

echo "$CopyRights";


##+++++++++++++++++++++++++++++++++++++++++++
## CHK Enviroment Section
##+++++++++++++++++++++++++++++++++++++++++++
SupportOS="SunOS Linux";


TargetOS=`uname -a | cut -d" " -f1`

case  "$TargetOS" in
      SunOS )
               Chk=true;
               DuOption="-ok";
               WhichAwk="nawk";
               ;;
     Linux )
               Chk=true;
               DuOption="-Sk";
               WhichAwk="gawk";
               ;;
     AIX )
               Chk=true;
               DuOption="-k";
               WhichAwk="awk";
               ;;
      * )
               Chk=false;
               DuOption="bad";
               echo " space dose not Support your Sytem !! [ support : $SupportOS ]";
               exit;

esac

echo " Start  ++ Pre Install  Section ++";

##+++++++++++++++++++++++++++++++++++++++++++
## Pre Install  Section
##+++++++++++++++++++++++++++++++++++++++++++


echo -n " INSALL sapce to /usr/bin/space  Yes/No : ";

read Inkey
echo  "  Input : $Inkey  ";
if [[  "Y" == "$Inkey" || "y" ==  "$Inkey" || "yes" ==  "$Inkey" || "Yes" == "$Inkey" ]]
then
    echo " Start  install ";
else
    echo " Stop  and exit";
    exit;
fi



##+++++++++++++++++++++++++++++++++++++++++++
## Pre Install  Section
##+++++++++++++++++++++++++++++++++++++++++++



cat > /usr/bin/space <<!
#!/bin/sh


${CopyRights}

clear;

if [ -z "\$1" ]
then
    APW="."
else
    APW="\$1"
    if [ ! -d "\$APW" ]
    then
        echo " Usage : \$0 [Directory name] : \$APW is not Dir !! ";
        APW=\$(dirname "\$APW" )
    fi
fi


echo "";
echo "";
echo "";
df -k ;

#APW=\`pwd\`

#for Sun Server
#du -ok . 2>/dev/null | nawk -F/ -v pas=$APW '
#for Linux Server
#du -Sk . 2>/dev/null | gawk -F/ -v pas=$APW '

cd "\$APW"; du ${DuOption} . 2>/dev/null | ${WhichAwk} -F/ -v pas=\$APW '
    BEGIN {
               print  "\t\t\t------------------------------";
               print  "\t\t\t DIsk Usae of current Dir V2.1";
               print  "\t\t\t------------------------------";
               printf "\t\t\t [%s] \n\n", pas;

               printf"\t-----------------------------------------------------------------------\n"
               printf"\t%-40s : %10s   : %10s \n","DIRNAME", "SIZE (MB)","Subdir cnt";
               printf"\t-----------------------------------------------------------------------\n"

               tots=0;
               tcnt=0;
               i=0;
           }
           {
                pos=index(\$1, ".");
                size=substr(\$1,1, pos-1);
                gsub(" ","" , \$2);

                tcnt++;
                tots+=size;

                if ( NR ==1 )
                {
                    dirs=\$2;
                    dsize=0;
                    dcnt=0;
                }

                if ( dirs == \$2 )
                {
                    dsize+=size;
                    dcnt++;
                }
                else
                {
                  # printf"\t%-40s : %10.2fMB : %10d \n",dirs, dsize/1024, dcnt;
                    DIR[i]=dirs;
                    Dsize[i]=dsize/1024;
                    Dcnt[i]=dcnt;

                    dirs=\$2;
                    dsize=size;
                    dcnt=1;
                    i = i + 1;
                }

            }
        END {
                    DIR[i]  = "./";
                    Dsize[i]=dsize/1024;
                    Dcnt[i]=dcnt;

                    # SORT SECTION
                    for ( j=0; j<i ; j++ )
                    {
                        for ( k=j+1; k<=i ; k++ )
                        {
                           if ( Dsize[j] > Dsize [k]){
                               tmp1=DIR[j];
                               tmp2=Dsize[j];
                               tmp3=Dcnt[j];

                               DIR[j]=DIR[k];
                               Dsize[j]=Dsize[k];
                               Dcnt[j]=Dcnt[k];

                               DIR[k]=tmp1;
                               Dsize[k]=tmp2;
                               Dcnt[k]=tmp3;
                           }
                        }
                    }

                    # PRINT SECTION
                    for ( j=0; j<=i ; j++ )
                    {
                        printf"\t%-40s : %10.2fMB : %10d \n",DIR[j], Dsize[j], Dcnt[j];
                    }
                    printf"\t-----------------------------------------------------------------------\n"
                    printf"\t%-40s : %10.2fMB : %10d \n","TOTALSIZE", tots/1024, tcnt;
                    printf"\t-----------------------------------------------------------------------\n"
                    printf"\t      --  Copy Right @ Choi Doo Rip  2001 01 09  --  \n"

            }'
!


chmod 755 /usr/bin/space

exit 0
