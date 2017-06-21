if [ -f "result_TCP.txt" ]
then
   rm result_TCP.txt
fi

if [ -f "throughput_summary_TCP" ]
then
   rm throughput_summary_TCP
fi

largest=0.0
smallest=1000000.0
average=0.0
total=0.0
large=10
small=10
node=0
echo "core_no   throughput">>throughput_summary_TCP
for((i=0;i<32;++i))
do
  node=`expr $i / 8`
  ssh root@192.168.1.125   virsh vcpupin 16 0 $i
  ssh root@192.168.1.125   virsh numatune new-ellis --nodeset $node

  sleep 10
  netperf -t TCP_STREAM -H 192.168.122.83 -l 60 -p 1300  --  -m 65536 -M 65536 >>result_TCP.txt
  itr=`expr $i + 1`
  line=`expr 7 \* $itr`
  echo $itr
  throughput=`cat result_TCP.txt | sed -n "${line}p" | awk '{print $5}'`
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

  echo "$i        $throughput">>throughput_summary_TCP
  ssh root@192.168.1.125 virsh vcpuinfo 16
  ssh root@192.168.1.125 numastat -c qemu-kvm
done
echo "total is $total">>throughput_summary_TCP
echo "smallest is $smallest">>throughput_summary_TCP
echo "largest is $largest">>throughput_summary_TCP
average=`echo "$total / 32" | bc`
echo "average is $average">>throughput_summary_TCP
