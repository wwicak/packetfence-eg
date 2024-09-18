package maint

import (
	"net/netip"
	"testing"
	"time"
)

func TestAggregator(t *testing.T) {
	networkEventChan := make(chan []*NetworkEvent, 100)
	events := []*PfFlows{
		{
			Flows: &[]PfFlow{
				{
					SrcIp:       netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:       netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort:     1024,
					DstPort:     80,
					Proto:       6,
					BiFlow:      1,
					PacketCount: 1,
				},
				{
					SrcIp:       netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:       netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort:     1025,
					DstPort:     80,
					Proto:       6,
					BiFlow:      1,
					PacketCount: 1,
				},
				{
					SrcIp:       netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					DstIp:       netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					SrcPort:     80,
					DstPort:     1025,
					Proto:       6,
					BiFlow:      2,
					PacketCount: 1,
				},
				{
					SrcIp:       netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:       netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort:     1024,
					DstPort:     80,
					Proto:       6,
					BiFlow:      1,
					PacketCount: 1,
				},
			},
		},
	}

	a := NewAggregator(
		&AggregatorOptions{
			Timeout:          10 * time.Millisecond,
			NetworkEventChan: networkEventChan,
		},
	)

	go a.handleEvents()
	a.PfFlowsChan <- events
	ne := <-networkEventChan
	if len(ne) != 1 {
		t.Fatalf("Not aggreated to a single network event")
	}

	if ne[0].Count != 4 {
		t.Fatalf("Not aggreated properly")
	}

	events = []*PfFlows{
		{
			Flows: &[]PfFlow{
				{
					SrcIp:   netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:   netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort: 1024,
					DstPort: 80,
					Proto:   6,
					BiFlow:  0,
				},
				{
					SrcIp:   netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:   netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort: 1025,
					DstPort: 80,
					Proto:   6,
					BiFlow:  0,
				},
				{
					SrcIp:   netip.AddrFrom4([4]byte{1, 1, 1, 1}),
					DstIp:   netip.AddrFrom4([4]byte{1, 1, 1, 2}),
					SrcPort: 1024,
					DstPort: 80,
					Proto:   6,
					BiFlow:  0,
				},
			},
		},
	}
	a.PfFlowsChan <- events
	ne = <-networkEventChan
	if len(ne) != 1 {
		t.Fatalf("Not aggreated to a single network event")
	}

	if ne[0].Count != 3 {
		t.Fatalf("Not aggreated properly")
	}

	events = []*PfFlows{
		{
			Flows: &[]PfFlow{
				{
					SrcIp:       netip.AddrFrom4([4]byte{10, 15, 1, 2}),
					DstIp:       netip.AddrFrom4([4]byte{10, 15, 1, 6}),
					SrcPort:     223,
					DstPort:     52180,
					Proto:       6,
					BiFlow:      2,
					PacketCount: 12,
				},
				{
					SrcIp:       netip.AddrFrom4([4]byte{10, 15, 1, 6}),
					DstIp:       netip.AddrFrom4([4]byte{10, 15, 1, 2}),
					SrcPort:     52180,
					DstPort:     223,
					Proto:       6,
					BiFlow:      1,
					Direction:   1,
					PacketCount: 18,
				},
			},
		},
	}
	a.PfFlowsChan <- events
	ne = <-networkEventChan
	if len(ne) != 1 {
		t.Fatalf("Not aggreated to a single network event")
	}

	if ne[0].Count != 30 {
		t.Fatalf("Not aggreated properly")
	}

	if ne[0].DestPort != 223 {
		t.Fatalf("Not aggreated properly wrong port")
	}

}
