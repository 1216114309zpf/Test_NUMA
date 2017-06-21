result_file="APACHE_10000_10_RESULT"
result_summary_file="APACHE_10000_10_RESULT_SUMMARY"
if [ -f $result_file ]
then
   rm $result_file
fi

if [ -f $result_summary_file ]
then
   rm $result_summary_file
fi

largest=0.0
smallest=1000000.0
average=0.0
total=0.0
large=10
small=10
node=0

for((i=0;i<32;++i))
do
  node=`$i / 8`
  ssh root@192.168.1.125   virsh vcpupin 16 0 $i
  ssh root@192.168.1.125   virsh numatune new-ellis --nodeset $node

  sleep 10
  ab -n 10000 -c 10 http://192.168.122.83:8200/index.html  >> $result_file
  ssh root@192.168.1.125 virsh vcpuinfo 16
  ssh root@192.168.1.125 numastat -c qemu-kvm
done

echo "core_no   requests_per_second">>$result_summary_file

grep "Requests per second" $result_file >>tmpfile

for ((j=1;j<33;++j))
do
  throughput=`cat tmpfile | sed -n "${j}p" | awk '{print $4}'`

  total=`echo "$total + $throughput" |bc`
  large=`echo "$throughput > $largest" | bc`
  small=`echo "$smallest > $throughput" |bc`

  if [ $large -eq 1 ]
  then
     largest=$throughput
  elif [ $small -eq 1 ]
  then
     smallest=$throughput
  fi

  echo "$j        $throughput">>$result_summary_file

done

rm tmpfile

echo "total is $total">>$result_summary_file
echo "smallest is $smallest">>$result_summary_file
echo "largest is $largest">>$result_summary_file
average=`echo "$total / 32" | bc`
echo "average is $average">>$result_summary_file

