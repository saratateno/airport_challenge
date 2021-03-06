require 'airport'

describe Airport do

  describe '#initialize' do
    it 'sets capacity to the argument passed' do
      expect(Airport.new(30).capacity).to eq(30)
    end

    it 'if no argument is passed, set\'s capacity to default capacity' do
      expect(subject.capacity).to eq(Airport::DEFAULT_CAPACITY)
    end
  end

  context 'behaviour when the weather is fine' do
    before {allow(Kernel).to receive(:rand).with(100) {99}}

    let(:airborne_plane) {double :plane, flying: true}
    let(:landed_plane) {double :plane, flying: false}

    describe '#land' do
      it 'raises an error when trying to land a plane that is not flying' do
        expect { subject.land(landed_plane) }.to raise_error 'Cannot land. Plane has already landed.'
      end

      it 'raises an error when the airport is full' do
        plane = double(:plane, landplane: false, flying: true)
        subject.capacity.times {subject.land(plane)}
        expect { subject.land(plane) }.to raise_error 'Cannot land. Airport is full.'
      end

      it 'tells the plane to follow its landing procedures upon landing' do
        expect(airborne_plane).to receive(:landplane)
        subject.land(airborne_plane)
      end
    end

    describe '#takeoff' do
      it 'raises an error when trying to takeoff a plane that is already flying' do
        expect { subject.takeoff(airborne_plane) }.to raise_error 'Cannot instruct takeoff. Plane is already flying.'
      end

      it 'raises an error if instructing a plane that is not in the current airport' do
        missing_plane = double(:plane, takeoff_plane: false, flying: false)
        expect { subject.takeoff(missing_plane) }.to raise_error 'Cannot takeoff. Plane is not in airport'
      end

      it 'tells the plane to follow its takeoff procedures upon takeoff' do
        allow(subject).to receive(:missing).and_return(false)
        expect(landed_plane).to receive(:takeoff_plane)
        subject.takeoff(landed_plane)
      end
    end

    describe '#planes' do
      it 'should return an array with the planes that have landed' do
        planes_array = []
        plane = double(:plane, landplane: false, flying: true)
        2.times do
           planes_array << plane
           subject.land(plane)
        end
        expect(subject.planes).to match_array(planes_array)
      end
    end
  end

  context 'behaviour in stormy weather' do
    before {allow(Kernel).to receive(:rand).with(100) {1}}
    let(:plane) {double :plane, flying: false}

    describe '#land' do
      it 'raises an error when trying to land a plane in stormy weather' do
        expect { subject.land(plane) }.to raise_error 'Cannot land. Stormy weather.'
      end
    end

    describe '#takeoff' do
      it 'raises an error when trying to takeoff in stormy weather' do
        expect { subject.takeoff(plane) }.to raise_error 'Cannot instruct takeoff. Stormy weather.'
      end
    end
  end

  describe '#weather' do
    it 'changes the weather to stormy with a random function' do
      allow(Kernel).to receive(:rand).with(100) {1}
      expect(subject.is_stormy?).to eq true
    end
  end

end
